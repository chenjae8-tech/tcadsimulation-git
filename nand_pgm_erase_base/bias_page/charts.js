/* Shared paper-style chart engine for TCAD_SDEVICE result-report Artifacts.
   Canonical copy — see report_template/README.md before editing.
   Line charts on canvas: linear or log y, boxed frame with inward ticks
   (+ log minor ticks), open-symbol markers per series, hover crosshair +
   tooltip, dashed phase separators, direct end labels, theme-aware
   redraw, copy-as-PNG. Wire up a report's own data at the marked
   insertion point below — see README.md for the makeChart() cfg fields. */
(function () {
  "use strict";

  var SUP = { "-": "⁻", 0: "⁰", 1: "¹", 2: "²", 3: "³",
              4: "⁴", 5: "⁵", 6: "⁶", 7: "⁷", 8: "⁸", 9: "⁹" };
  function sup(n) { return String(n).split("").map(function (c) { return SUP[c] || c; }).join(""); }
  function css(v) { return getComputedStyle(document.documentElement).getPropertyValue(v).trim(); }
  function fmtSci(v) {
    if (v === 0) return "0";
    var e = Math.floor(Math.log(Math.abs(v)) / Math.LN10);
    var m = v / Math.pow(10, e);
    return m.toFixed(2) + "×10" + sup(e);
  }

  // Journal-figure typography: a single plain sans stack for all chart text
  // (no monospace digits, no mixed UI font) — matches how axis text is set
  // in device-physics papers (Arial/Helvetica), independent of the report's
  // own IBM Plex page font.
  var F_SANS = 'Arial, "Helvetica Neue", Helvetica, sans-serif';

  var charts = [];

  function makeChart(cfg) {
    var cv = document.getElementById(cfg.canvas);
    if (!cv) return;
    var ctx = cv.getContext("2d");
    var hintEl = cfg.hint ? document.getElementById(cfg.hint) : null;
    var hintDefault = hintEl ? hintEl.textContent : "";
    var hover = null;

    // ---- normalise series to point arrays ----
    var series = cfg.series.map(function (s) {
      var pts = [];
      if (s.pts) {
        pts = s.pts.slice();
      } else {
        for (var i = 0; i < cfg.xs.length; i++) {
          var y = s.ys[i];
          if (y === null || y === undefined || !isFinite(y)) continue;
          pts.push([cfg.xs[i], y]);
        }
      }
      return { name: s.name, cssVar: s.cssVar, dash: s.dash, width: s.width, pts: pts, label: s.label, marker: s.marker };
    });

    // ---- ranges ----
    var xMin = cfg.xMin, xMax = cfg.xMax, yMin = cfg.yMin, yMax = cfg.yMax;
    if (xMin === undefined || xMax === undefined || yMin === undefined || yMax === undefined) {
      var a = Infinity, b = -Infinity, c = Infinity, d = -Infinity;
      series.forEach(function (s) {
        s.pts.forEach(function (p) {
          if (cfg.xMin !== undefined && p[0] < cfg.xMin) return;
          if (cfg.xMax !== undefined && p[0] > cfg.xMax) return;
          if (p[0] < a) a = p[0]; if (p[0] > b) b = p[0];
          var yv = p[1];
          if (cfg.yLog && !(yv > 0)) return;
          if (yv < c) c = yv; if (yv > d) d = yv;
        });
      });
      if (xMin === undefined) xMin = a;
      if (xMax === undefined) xMax = b;
      if (cfg.yLog) {
        if (yMin === undefined) yMin = Math.floor(Math.log(c) / Math.LN10);
        if (yMax === undefined) yMax = Math.ceil(Math.log(d) / Math.LN10);
      } else {
        var pad = (d - c) * 0.08 || 1;
        if (yMin === undefined) yMin = c - pad;
        if (yMax === undefined) yMax = d + pad;
      }
    }

    // ---- legend: line-sample + open-symbol swatch, like a figure legend ----
    function markerPath(shape, mx, y, r) {
      if (shape === "square") return '<rect x="' + (mx - r) + '" y="' + (y - r) + '" width="' + (r * 2) + '" height="' + (r * 2) + '"/>';
      if (shape === "triangle") return '<polygon points="' + mx + ',' + (y - r * 1.15) + ' ' + (mx + r * 1.05) + ',' + (y + r * 0.8) + ' ' + (mx - r * 1.05) + ',' + (y + r * 0.8) + '"/>';
      if (shape === "diamond") return '<polygon points="' + mx + ',' + (y - r * 1.3) + ' ' + (mx + r * 1.3) + ',' + y + ' ' + mx + ',' + (y + r * 1.3) + ' ' + (mx - r * 1.3) + ',' + y + '"/>';
      if (shape === "cross") return '<path d="M' + (mx - r) + ' ' + (y - r) + ' L' + (mx + r) + ' ' + (y + r) + ' M' + (mx + r) + ' ' + (y - r) + ' L' + (mx - r) + ' ' + (y + r) + '" fill="none"/>';
      return '<circle cx="' + mx + '" cy="' + y + '" r="' + r + '"/>';
    }
    function svgSwatch(cssVar, dash, marker) {
      var color = "var(" + cssVar + ")";
      var y = 8, x1 = 1, x2 = 27, mx = 14, r = 3.4;
      var dashAttr = dash ? ' stroke-dasharray="' + (dash === true ? "7,4" : dash.join(",")) + '"' : "";
      var svg = '<svg width="28" height="16" viewBox="0 0 28 16" aria-hidden="true" focusable="false">';
      svg += '<line x1="' + x1 + '" y1="' + y + '" x2="' + x2 + '" y2="' + y + '" stroke="' + color + '" stroke-width="2.1"' + dashAttr + '/>';
      if (marker && marker !== "cross") {
        svg += '<g fill="var(--surface)" stroke="' + color + '" stroke-width="1.5">' + markerPath(marker, mx, y, r) + '</g>';
      } else if (marker === "cross") {
        svg += '<g stroke="' + color + '" stroke-width="1.6">' + markerPath(marker, mx, y, r + 0.4) + '</g>';
      }
      svg += '</svg>';
      return svg;
    }
    if (cfg.legend) {
      var lg = document.getElementById(cfg.legend);
      if (lg) {
        lg.innerHTML = "";
        series.forEach(function (s) {
          var el = document.createElement("span");
          el.className = "lg";
          el.innerHTML = svgSwatch(s.cssVar, s.dash, s.marker);
          el.appendChild(document.createTextNode(s.name));
          lg.appendChild(el);
        });
      }
    }

    // A point is drawn only if it actually lies inside the y range. On a log
    // axis, clamping instead would paint a flat line along the floor — data
    // that is off-scale must leave the chart, not pretend to sit on the edge.
    function plottable(v) {
      if (v === null || v === undefined || !isFinite(v)) return false;
      if (cfg.yLog) {
        if (!(v > 0)) return false;
        return Math.log(v) / Math.LN10 >= yMin;
      }
      return true;
    }

    function drawMarker(shape, x, y, r, color) {
      ctx.save();
      ctx.fillStyle = css("--surface");
      ctx.strokeStyle = color;
      ctx.lineWidth = 1.6;
      ctx.beginPath();
      if (shape === "square") {
        ctx.rect(x - r, y - r, r * 2, r * 2);
      } else if (shape === "triangle") {
        ctx.moveTo(x, y - r * 1.15); ctx.lineTo(x + r * 1.05, y + r * 0.8); ctx.lineTo(x - r * 1.05, y + r * 0.8); ctx.closePath();
      } else if (shape === "diamond") {
        ctx.moveTo(x, y - r * 1.3); ctx.lineTo(x + r * 1.3, y); ctx.lineTo(x, y + r * 1.3); ctx.lineTo(x - r * 1.3, y); ctx.closePath();
      } else if (shape === "cross") {
        ctx.moveTo(x - r, y - r); ctx.lineTo(x + r, y + r); ctx.moveTo(x + r, y - r); ctx.lineTo(x - r, y + r);
      } else {
        ctx.arc(x, y, r, 0, Math.PI * 2);
      }
      if (shape === "cross") ctx.stroke(); else { ctx.fill(); ctx.stroke(); }
      ctx.restore();
    }

    function px(v, m) { return m.L + (v - xMin) / (xMax - xMin) * m.w; }
    function py(v, m) {
      if (cfg.yLog) {
        var l = Math.log(Math.max(v, 1e-300)) / Math.LN10;
        if (l < yMin) l = yMin; if (l > yMax) l = yMax;
        return m.T + (yMax - l) / (yMax - yMin) * m.h;
      }
      var vv = Math.max(yMin, Math.min(yMax, v));
      return m.T + (yMax - vv) / (yMax - yMin) * m.h;
    }

    function niceTicks(lo, hi, want) {
      var span = hi - lo;
      if (!(span > 0)) return [lo];
      var raw = span / want;
      var mag = Math.pow(10, Math.floor(Math.log(raw) / Math.LN10));
      var norm = raw / mag;
      var step = (norm <= 1 ? 1 : norm <= 2 ? 2 : norm <= 5 ? 5 : 10) * mag;
      var out = [], t = Math.ceil(lo / step) * step;
      for (; t <= hi + step * 1e-9; t += step) out.push(+t.toFixed(10));
      return out;
    }

    function draw() {
      var box = cv.getBoundingClientRect().width;
      if (!box) box = (cv.parentElement.clientWidth || 600) - 32;
      var W = Math.max(260, Math.round(box));
      var narrow = W < 460;
      var H = Math.round(cfg.tall ? W * 0.78 : (narrow ? W * 0.85 : Math.min(cfg.maxH || 400, W * (cfg.ratio || 0.50))));
      var dpr = Math.min(window.devicePixelRatio || 1, 2);
      cv.width = Math.round(W * dpr); cv.height = Math.round(H * dpr);
      cv.style.height = H + "px";
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

      var m = { L: narrow ? 64 : 82, R: cfg.padRight || 16, T: 14, B: narrow ? 60 : 60 };
      m.w = W - m.L - m.R; m.h = H - m.T - m.B;

      var ink = css("--ink"), gridS = css("--grid-strong"), surface = css("--surface"), sub = css("--ink-2");

      ctx.fillStyle = surface; ctx.fillRect(0, 0, W, H);

      var TICK = narrow ? 4.5 : 5.5, TICKM = narrow ? 2.5 : 3;

      // phase separators: dashed rules + italic labels, no shaded blocks —
      // the annotated-region convention used for bias/timing diagrams in
      // device papers, instead of a dashboard-style alternating background.
      if (cfg.bands) {
        ctx.save();
        cfg.bands.forEach(function (bd, i) {
          var x0 = px(Math.max(bd.x0, xMin), m), x1 = px(Math.min(bd.x1, xMax), m);
          if (x1 <= x0) return;
          if (i > 0 && x0 > m.L + 0.5 && x0 < m.L + m.w - 0.5) {
            ctx.strokeStyle = gridS; ctx.lineWidth = 1; ctx.setLineDash([3, 3]);
            ctx.beginPath(); ctx.moveTo(x0, m.T); ctx.lineTo(x0, m.T + m.h); ctx.stroke();
          }
          ctx.setLineDash([]);
          ctx.fillStyle = sub;
          ctx.font = 'italic 500 ' + (narrow ? 9.5 : 10.5) + 'px ' + F_SANS;
          ctx.textAlign = "center"; ctx.textBaseline = "top";
          if (x1 - x0 > 46 && bd.label) ctx.fillText(bd.label, (x0 + x1) / 2, m.T + 5);
        });
        ctx.restore();
      }

      // 2026-10-10: axis titles 13.5 -> 17 px (user asked for bigger y-axis text).
      // 2026-09-21: bumped from 11/12.5 (user asked for bigger axis-scale
      // numbers) — margins above (m.L/m.B) widened to match.
      var tickFont = '500 ' + (narrow ? 13.5 : 15.5) + 'px ' + F_SANS;
      ctx.font = tickFont; ctx.lineWidth = 1;

      // y ticks — inward on both the left and right frame (boxed-axis
      // convention), zero kept as a full-width reference rule, everything
      // else as short ticks rather than a gridline running across the plot.
      var yticks = [];
      if (cfg.yLog) {
        for (var e = Math.ceil(yMin); e <= Math.floor(yMax); e++) yticks.push(e);
        var stride = yticks.length > 9 ? Math.ceil(yticks.length / 8) : 1;
        yticks = yticks.filter(function (_, i) { return i % stride === 0; });
      } else {
        yticks = niceTicks(yMin, yMax, narrow ? 4 : 6);
      }
      yticks.forEach(function (t) {
        var val = cfg.yLog ? Math.pow(10, t) : t;
        var y = Math.round(py(val, m)) + 0.5;
        var isZero = !cfg.yLog && Math.abs(t) < 1e-12;
        ctx.strokeStyle = isZero ? gridS : ink;
        ctx.beginPath();
        if (isZero) { ctx.moveTo(m.L, y); ctx.lineTo(m.L + m.w, y); }
        else { ctx.moveTo(m.L, y); ctx.lineTo(m.L + TICK, y); ctx.moveTo(m.L + m.w - TICK, y); ctx.lineTo(m.L + m.w, y); }
        ctx.stroke();
        ctx.fillStyle = ink; ctx.textAlign = "right"; ctx.textBaseline = "middle";
        ctx.fillText(cfg.yLog ? "10" + sup(t) : (cfg.fmtY ? cfg.fmtY(t) : String(t)), m.L - 9, y);
      });
      // minor log ticks at 2,3,…9×10^e — unlabelled, shorter, standard on a
      // semi-log axis in a printed figure.
      if (cfg.yLog) {
        for (var e2 = Math.floor(yMin) - 1; e2 <= Math.ceil(yMax); e2++) {
          for (var k = 2; k <= 9; k++) {
            var lv = e2 + Math.log(k) / Math.LN10;
            if (lv <= yMin || lv >= yMax) continue;
            var ym = Math.round(m.T + (yMax - lv) / (yMax - yMin) * m.h) + 0.5;
            ctx.strokeStyle = ink;
            ctx.beginPath();
            ctx.moveTo(m.L, ym); ctx.lineTo(m.L + TICKM, ym);
            ctx.moveTo(m.L + m.w - TICKM, ym); ctx.lineTo(m.L + m.w, ym);
            ctx.stroke();
          }
        }
      }

      // x ticks — inward on both the bottom and top frame.
      var xticks = niceTicks(xMin, xMax, narrow ? 4 : 7);
      xticks.forEach(function (t) {
        var x = Math.round(px(t, m)) + 0.5;
        var isZero = Math.abs(t) < 1e-12 && xMin < 0;
        ctx.strokeStyle = isZero ? gridS : ink;
        ctx.beginPath();
        if (isZero) { ctx.moveTo(x, m.T); ctx.lineTo(x, m.T + m.h); }
        else { ctx.moveTo(x, m.T); ctx.lineTo(x, m.T + TICK); ctx.moveTo(x, m.T + m.h - TICK); ctx.lineTo(x, m.T + m.h); }
        ctx.stroke();
        ctx.fillStyle = ink; ctx.textAlign = "center"; ctx.textBaseline = "top";
        ctx.fillText(cfg.fmtX ? cfg.fmtX(t) : String(t), x, m.T + m.h + 9);
      });

      // reference lines
      if (cfg.refs) {
        cfg.refs.forEach(function (r) {
          ctx.save();
          ctx.setLineDash([6, 4]); ctx.lineWidth = 1.6;
          ctx.strokeStyle = r.color ? css(r.color) : css("--accent");
          if (r.y !== undefined) {
            var y = Math.round(py(r.y, m)) + 0.5;
            ctx.beginPath(); ctx.moveTo(m.L, y); ctx.lineTo(m.L + m.w, y); ctx.stroke();
            ctx.restore();
            ctx.fillStyle = r.color ? css(r.color) : css("--accent");
            ctx.font = '600 ' + (narrow ? 10.5 : 12) + 'px ' + F_SANS;
            ctx.textAlign = "left"; ctx.textBaseline = "bottom";
            ctx.fillText(r.label, m.L + 8, y - 5);
          } else {
            var x = Math.round(px(r.x, m)) + 0.5;
            ctx.beginPath(); ctx.moveTo(x, m.T); ctx.lineTo(x, m.T + m.h); ctx.stroke();
            ctx.restore();
          }
        });
      }

      // series
      series.forEach(function (s) {
        ctx.save();
        ctx.strokeStyle = css(s.cssVar);
        ctx.lineWidth = s.width || 2.4;
        ctx.lineJoin = "round"; ctx.lineCap = "round";
        if (s.dash) ctx.setLineDash(s.dash === true ? [8, 5] : s.dash);
        ctx.beginPath();
        var pen = false;
        s.pts.forEach(function (p) {
          if (p[0] < xMin - 1e-12 || p[0] > xMax + 1e-12) { pen = false; return; }
          if (!plottable(p[1])) { pen = false; return; }
          var X = px(p[0], m), Y = py(p[1], m);
          if (!pen) { ctx.moveTo(X, Y); pen = true; } else ctx.lineTo(X, Y);
        });
        ctx.stroke();
        ctx.restore();
      });

      // open-symbol markers, evenly spaced along each visible curve — the
      // same condition keeps the same symbol in every figure in this report
      // (base = circle, HCI = square, …), so curves stay distinguishable
      // without relying on color alone.
      series.forEach(function (s) {
        if (!s.marker) return;
        var visible = s.pts.filter(function (p) {
          return p[0] >= xMin - 1e-9 && p[0] <= xMax + 1e-9 && plottable(p[1]);
        });
        if (!visible.length) return;
        var count = narrow ? 5 : 7, r = narrow ? 3 : 3.6;
        for (var mi = 0; mi < count; mi++) {
          var tx = xMin + (xMax - xMin) * (mi + 0.5) / count;
          var best = null;
          visible.forEach(function (p) { if (!best || Math.abs(p[0] - tx) < Math.abs(best[0] - tx)) best = p; });
          if (!best || Math.abs(best[0] - tx) > (xMax - xMin) / count * 0.6) continue;
          drawMarker(s.marker, px(best[0], m), py(best[1], m), r, css(s.cssVar));
        }
      });

      // Vt drop lines (IV chart)
      if (cfg.vts) {
        cfg.vts.forEach(function (v) {
          var X = px(v.x, m);
          if (X < m.L || X > m.L + m.w) return;
          ctx.save();
          ctx.strokeStyle = css(v.cssVar); ctx.lineWidth = 1.5; ctx.setLineDash([3, 3]);
          ctx.beginPath(); ctx.moveTo(X, py(1e-7, m)); ctx.lineTo(X, m.T + m.h); ctx.stroke();
          ctx.restore();
          ctx.fillStyle = css(v.cssVar);
          ctx.beginPath(); ctx.arc(X, py(1e-7, m), 4, 0, Math.PI * 2); ctx.fill();
          ctx.font = '600 ' + (narrow ? 11 : 12.5) + 'px ' + F_SANS;
          ctx.textAlign = v.align || "center"; ctx.textBaseline = "alphabetic";
          ctx.fillText(v.text, X + (v.dx || 0), m.T + m.h - 9);
        });
      }

      // direct end labels
      if (cfg.directLabels) {
        ctx.font = '600 ' + (narrow ? 10.5 : 12) + 'px ' + F_SANS;
        series.forEach(function (s) {
          if (!s.label) return;
          var best = null;
          s.pts.forEach(function (p) {
            if (p[0] < xMin || p[0] > xMax) return;
            if (!plottable(p[1])) return;
            if (s.label.at === "max") { if (!best || p[1] > best[1]) best = p; }
            else if (typeof s.label.at === "number") {
              if (!best || Math.abs(p[0] - s.label.at) < Math.abs(best[0] - s.label.at)) best = p;
            } else { best = p; }
          });
          if (!best) return;
          var X = px(best[0], m) + (s.label.dx || 0), Y = py(best[1], m) + (s.label.dy || -9);
          ctx.fillStyle = css(s.cssVar);
          ctx.textAlign = s.label.align || "center"; ctx.textBaseline = "alphabetic";
          ctx.fillText(s.label.text, Math.max(m.L + 14, Math.min(m.L + m.w - 14, X)), Y);
        });
      }

      // frame — solid black box on all four sides, journal-figure weight
      ctx.strokeStyle = ink; ctx.lineWidth = 1.3;
      ctx.strokeRect(m.L + 0.5, m.T + 0.5, m.w, m.h);

      // axis titles
      ctx.fillStyle = ink;
      axisTitle(cfg.xTitle, m.L + m.w / 2, H - 7, narrow);
      ctx.save();
      ctx.translate(narrow ? 15 : 19, m.T + m.h / 2);
      ctx.rotate(-Math.PI / 2);
      axisTitle(cfg.yTitle, 0, 4, narrow);
      ctx.restore();

      // hover layer
      if (hover) drawHover(m, narrow);
      lastM = m; lastNarrow = narrow;
    }

    var lastM = null, lastNarrow = false;

    function axisTitle(t, cx, by, narrow) {
      if (!t) return;
      // Physics-notation convention: the quantity symbol and its subscript
      // are italic, the unit stays roman — e.g. "V_GS (V)".
      var fB = 'italic 600 ' + (narrow ? 14.5 : 17) + 'px ' + F_SANS;
      var fS = 'italic 600 ' + (narrow ? 11 : 12.5) + 'px ' + F_SANS;
      var fU = '600 ' + (narrow ? 14.5 : 17) + 'px ' + F_SANS;
      ctx.textBaseline = "alphabetic"; ctx.textAlign = "left";
      ctx.font = fB; var wB = ctx.measureText(t.base).width;
      ctx.font = fS; var wS = t.sub ? ctx.measureText(t.sub).width : 0;
      ctx.font = fU; var wU = ctx.measureText("  " + t.unit).width;
      var x = cx - (wB + wS + wU) / 2;
      ctx.font = fB; ctx.fillText(t.base, x, by);
      if (t.sub) { ctx.font = fS; ctx.fillText(t.sub, x + wB, by + 3); }
      ctx.font = fU; ctx.fillText("  " + t.unit, x + wB + wS, by);
    }

    function drawHover(m, narrow) {
      var hx = hover.x;
      var rows = [];
      series.forEach(function (s) {
        var best = null;
        s.pts.forEach(function (p) {
          if (p[0] < xMin || p[0] > xMax) return;
          if (!plottable(p[1])) return;
          if (!best || Math.abs(p[0] - hx) < Math.abs(best[0] - hx)) best = p;
        });
        if (best) rows.push({ s: s, p: best });
      });
      if (!rows.length) return;
      var anchor = rows.reduce(function (a, r) {
        return (!a || Math.abs(r.p[0] - hx) < Math.abs(a.p[0] - hx)) ? r : a;
      }, null);
      var X = px(anchor.p[0], m);

      ctx.save();
      ctx.strokeStyle = css("--grid-strong"); ctx.lineWidth = 1; ctx.setLineDash([4, 3]);
      ctx.beginPath(); ctx.moveTo(X, m.T); ctx.lineTo(X, m.T + m.h); ctx.stroke();
      ctx.restore();

      rows.forEach(function (r) {
        var Y = py(r.p[1], m);
        ctx.fillStyle = css("--surface"); ctx.beginPath(); ctx.arc(px(r.p[0], m), Y, 5.5, 0, Math.PI * 2); ctx.fill();
        ctx.fillStyle = css(r.s.cssVar); ctx.beginPath(); ctx.arc(px(r.p[0], m), Y, 3.8, 0, Math.PI * 2); ctx.fill();
      });

      var fmt = cfg.fmtHover || function (v) { return fmtSci(v); };
      var lines = [(cfg.hoverX ? cfg.hoverX(anchor.p[0]) : String(anchor.p[0]))];
      rows.forEach(function (r) { lines.push(r.s.name + "  " + fmt(r.p[1])); });

      ctx.font = '500 ' + (narrow ? 11 : 12) + 'px ' + F_SANS;
      var wMax = 0;
      lines.forEach(function (l) { wMax = Math.max(wMax, ctx.measureText(l).width); });
      var bw = wMax + 26, bh = lines.length * 17 + 12;
      var bx = X + 14, by = m.T + 10;
      if (bx + bw > m.L + m.w) bx = X - bw - 14;
      if (bx < m.L) bx = m.L + 4;

      ctx.save();
      ctx.globalAlpha = 0.97;
      ctx.fillStyle = css("--surface");
      ctx.strokeStyle = css("--rule-2"); ctx.lineWidth = 1;
      if (ctx.roundRect) { ctx.beginPath(); ctx.roundRect(bx, by, bw, bh, 4); ctx.fill(); ctx.stroke(); }
      else { ctx.fillRect(bx, by, bw, bh); ctx.strokeRect(bx, by, bw, bh); }
      ctx.restore();

      ctx.textAlign = "left"; ctx.textBaseline = "middle";
      lines.forEach(function (l, i) {
        if (i === 0) { ctx.fillStyle = css("--ink"); ctx.font = '600 ' + (narrow ? 11 : 12) + 'px ' + F_SANS; }
        else {
          ctx.font = '500 ' + (narrow ? 11 : 12) + 'px ' + F_SANS;
          ctx.fillStyle = css(rows[i - 1].s.cssVar);
          ctx.fillRect(bx + 10, by + 6 + i * 17 + 6, 9, 3);
          ctx.fillStyle = css("--ink-2");
        }
        ctx.fillText(l, bx + (i === 0 ? 10 : 24), by + 6 + i * 17 + 8);
      });
    }

    function onMove(ev) {
      if (!lastM) return;
      var r = cv.getBoundingClientRect();
      var mx = ev.clientX - r.left;
      if (mx < lastM.L || mx > lastM.L + lastM.w) { if (hover) { hover = null; draw(); } return; }
      hover = { x: xMin + (mx - lastM.L) / lastM.w * (xMax - xMin) };
      draw();
    }
    function onLeave() { if (hover) { hover = null; draw(); } }
    cv.addEventListener("mousemove", onMove);
    cv.addEventListener("mouseleave", onLeave);
    cv.addEventListener("touchstart", function (e) { if (e.touches[0]) onMove(e.touches[0]); }, { passive: true });
    cv.addEventListener("touchmove", function (e) { if (e.touches[0]) onMove(e.touches[0]); }, { passive: true });

    charts.push({ draw: draw, cv: cv, hint: hintEl, hintDefault: hintDefault });
    draw();
  }

  // ---------------- copy as PNG ----------------
  document.addEventListener("click", function (ev) {
    var btn = ev.target.closest ? ev.target.closest("[data-copy]") : null;
    if (!btn) return;
    var id = btn.getAttribute("data-copy");
    var entry = charts.filter(function (c) { return c.cv.id === id; })[0];
    if (!entry) return;
    var hintEl = entry.hint;
    function say(msg) {
      if (!hintEl) return;
      hintEl.textContent = msg;
      setTimeout(function () { hintEl.textContent = entry.hintDefault; }, 3200);
    }
    try {
      entry.cv.toBlob(function (blob) {
        if (!blob) { say("복사 실패 — 우클릭 → “이미지 복사”를 써주세요."); return; }
        if (!navigator.clipboard || !window.ClipboardItem) {
          say("이 브라우저는 버튼 복사를 막습니다 — 우클릭 → “이미지 복사”."); return;
        }
        navigator.clipboard.write([new ClipboardItem({ "image/png": blob })]).then(function () {
          var t = btn.textContent; btn.textContent = "복사됨";
          say("클립보드에 PNG로 복사됐습니다. PPT에 바로 붙여넣으세요.");
          setTimeout(function () { btn.textContent = t; }, 2000);
        }, function () { say("복사 권한이 거부됐습니다 — 우클릭 → “이미지 복사”."); });
      }, "image/png");
    } catch (err) { say("복사 실패 — 우클릭 → “이미지 복사”를 써주세요."); }
  });


  // ---------------- build the charts (per-report) ----------------
  // Everything above this line is the shared, data-agnostic engine — do not
  // change it here; edit report_template/chart-engine.js in the project and
  // re-copy (see report_template/README.md "propagating a template change").
  //
  // Everything below is THIS report's own wiring: your data objects (however
  // you name them — the ALO 5-gate report used window.D / window.IV from a
  // sibling data.js/iv.js) and one makeChart({...}) call per canvas. Example:
  //
  //   var D = window.D || {};
  //   if (D.myWaveform) {
  //     makeChart({
  //       canvas: "cMyChart", legend: "lgMyChart", hint: "hMyChart",
  //       xs: D.myWaveform.t,
  //       series: [
  //         { name: "base", cssVar: "--s-base", ys: D.myWaveform.base, marker: "circle" },
  //         { name: "HCI",  cssVar: "--s-hci",  ys: D.myWaveform.hci,  marker: "square", dash: [7, 4] }
  //       ],
  //       yLog: true, xMin: 0, xMax: 650, yMin: 2, yMax: 13,
  //       xTitle: { base: "t", sub: "", unit: "(µs)" },
  //       yTitle: { base: "I", sub: "D", unit: "(A)" },
  //       bands: [{ x0: 0, x1: 100, label: "rising" }, { x0: 100, x1: 600, label: "hold" }],
  //       fmtX: function (v) { return v.toFixed(0); }, hoverX: function (v) { return v + " µs"; },
  //       fmtHover: function (v) { return v.toExponential(2) + " A"; }
  //     });
  //   }
  //
  // cfg fields (all optional except canvas/series):
  //   canvas, legend, hint      — element ids in the host HTML
  //   xs, series[].ys           — shared x array + per-series y array, OR
  //   series[].pts              — per-series [x,y] pairs (use this for I-V
  //                               curves etc. that don't share one x axis)
  //   series[].cssVar           — a color CSS var defined on :root, e.g. "--s-base"
  //   series[].marker           — "circle" | "square" | "triangle" | "diamond" | "cross" | omit
  //                               ASSIGN BY CONDITION, NOT BY POSITION: the same
  //                               condition (e.g. "base" vs "HCI", or a fixed
  //                               location like "SG") should keep the same
  //                               marker in every figure across the whole report.
  //   series[].dash             — true (default dash) or an explicit [on, off] array
  //   series[].width            — line width in px (default 2.4)
  //   series[].label            — direct end-label: { text, at: "max"|<x-value>, dx, dy, align }
  //   xMin/xMax/yMin/yMax       — omit to auto-range from the data
  //   yLog                      — log10 y axis (adds minor ticks automatically)
  //   xTitle/yTitle             — { base, sub, unit } — base+sub render italic
  //                               (physics-notation convention), unit roman
  //   bands                     — [{ x0, x1, label }] phase separators (dashed
  //                               line + italic label at each boundary, no fill)
  //   refs                      — [{ y: <value>, label }] or [{ x: <value> }]
  //                               dashed reference line (e.g. a read-current criterion)
  //   vts                       — [{ x, cssVar, text, align, dx }] Vt-style drop
  //                               line + dot + label at y = 1e-7 (built for Id-Vgs)
  //   directLabels              — true to render series[].label entries
  //   tall / maxH / ratio       — sizing hints; padRight for extra right margin
  //   fmtX/fmtY/fmtHover/hoverX — number/label formatting callbacks
  //
  // See the ALO 5-gate GIDL erase report for a full worked example (all six
  // figure types): https://claude.ai/artifact/R5UGwAxNzRaoUceocR3ZpU
  //   (list_files → charts.js on that artifact shows the historical bottom
  //   section this placeholder replaces, before it was split out into this
  //   shared template.)

  // ---- this page: electrode bias of the base PGM+Erase command, read from the command file ----
  var BI = window.BIAS || {};
  if (BI.base) {
    var b = BI.base;
    var scale = function (pts, f, off) { return pts.map(function (p) { return [(p[0] - (off || 0)) * f, p[1]]; }); };
    // fixed node -> colour/marker mapping, kept in every figure
    var NODE = {
      SL:   { name: "SL",            cssVar: "--n-sl",   marker: "circle" },
      BL:   { name: "BL",            cssVar: "--n-bl",   marker: "cross", dash: [6, 4] },
      SGDG: { name: "SG = DG",       cssVar: "--n-sgdg", marker: "square" },
      PASS: { name: "WL_PASS",       cssVar: "--n-pass", marker: "triangle" },
      SEL:  { name: "WL_SEL (선택)", cssVar: "--n-sel",  marker: "diamond" }
    };
    var mk = function (n, pts, extra) { var s = Object.assign({}, NODE[n], { pts: pts, width: 2 }); return Object.assign(s, extra || {}); };
    var all = function (f, off) {
      return [mk("SEL", scale(b.WL_SEL, f, off)), mk("PASS", scale(b.WL_PASS, f, off)), mk("SGDG", scale(b.SG, f, off)),
              mk("BL", scale(b.BL, f, off)), mk("SL", scale(b.SL, f, off))];
    };
    var vfmt = function (v) { return v.toFixed(2) + " V"; };

    makeChart({
      canvas: "cOverview", legend: "lgOverview", hint: "hOverview", series: all(1e-3),
      xMin: 0, xMax: 82, yMin: -8, yMax: 24,
      bands: [{ x0: 0, x1: 71.718, label: "ISPP 15계단 (계단마다 read)" }, { x0: 71.718, x1: 76.898, label: "GIDL 소거" }, { x0: 76.898, x1: 81.652, label: "read" }],
      xTitle: { base: "t", sub: "", unit: "(ms)" }, yTitle: { base: "V", sub: "", unit: "(V)" },
      fmtX: function (v) { return v.toFixed(0); }, hoverX: function (v) { return v.toFixed(3) + " ms"; }, fmtHover: vfmt
    });
    makeChart({
      canvas: "cStep", legend: "lgStep", hint: "hStep", series: all(1),
      xMin: 0, xMax: 62, yMin: -8, yMax: 17,
      bands: [{ x0: 0, x1: 10, label: "켜기" }, { x0: 10, x1: 33, label: "S0 read" }, { x0: 33, x1: 53, label: "S1 PGM" }, { x0: 53, x1: 58, label: "" }, { x0: 58, x1: 62, label: "S1 read →" }],
      xTitle: { base: "t", sub: "", unit: "(µs)" }, yTitle: { base: "V", sub: "", unit: "(V)" },
      fmtX: function (v) { return v.toFixed(0); }, hoverX: function (v) { return v.toFixed(2) + " µs"; }, fmtHover: vfmt
    });
    makeChart({
      canvas: "cIspp", legend: "lgIspp", hint: "hIspp",
      series: [Object.assign({}, NODE.SEL, { name: "WL_SEL 프로그램 펄스 높이 (V_PGM)", pts: BI.ispp, width: 1.6 })],
      xMin: 0, xMax: 16, yMin: 14, yMax: 23,
      xTitle: { base: "계단", sub: "", unit: "(#)" }, yTitle: { base: "V", sub: "PGM", unit: "(V)" },
      fmtX: function (v) { return v.toFixed(0); }, hoverX: function (v) { return "계단 " + v.toFixed(0); }, fmtHover: vfmt
    });
    makeChart({
      canvas: "cErase", legend: "lgErase", hint: "hErase", series: all(1e-3),
      xMin: 71.6, xMax: 77.1, yMin: -8, yMax: 20,
      bands: [{ x0: 71.718, x1: 71.818, label: "상승" }, { x0: 71.818, x1: 76.818, label: "유지 5 ms" }, { x0: 76.818, x1: 76.898, label: "" }],
      xTitle: { base: "t", sub: "", unit: "(ms)" }, yTitle: { base: "V", sub: "", unit: "(V)" },
      fmtX: function (v) { return v.toFixed(1); }, hoverX: function (v) { return v.toFixed(4) + " ms"; }, fmtHover: vfmt
    });
    makeChart({
      canvas: "cEraseRise", legend: "lgEraseRise", hint: "hEraseRise", series: all(1, 71718),
      xMin: -10, xMax: 160, yMin: -1, yMax: 20,
      bands: [{ x0: 0, x1: 50, label: "SG·DG 0 V" }, { x0: 50, x1: 100, label: "SG·DG = SL − 9 V" }, { x0: 100, x1: 160, label: "유지" }],
      xTitle: { base: "t − t", sub: "ERS", unit: "(µs)" }, yTitle: { base: "V", sub: "", unit: "(V)" },
      fmtX: function (v) { return v.toFixed(0); }, hoverX: function (v) { return v.toFixed(1) + " µs"; }, fmtHover: vfmt
    });
  }

  // ---------------- redraw hooks ----------------
  var rt = null;
  window.addEventListener("resize", function () {
    clearTimeout(rt);
    rt = setTimeout(function () { charts.forEach(function (c) { c.draw(); }); }, 120);
  });
  function redrawAll() { charts.forEach(function (c) { c.draw(); }); }
  if (window.matchMedia) {
    var mq = window.matchMedia("(prefers-color-scheme: dark)");
    if (mq.addEventListener) mq.addEventListener("change", redrawAll);
  }
  new MutationObserver(redrawAll).observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] });
  if (document.fonts && document.fonts.ready) document.fonts.ready.then(redrawAll);
})();
