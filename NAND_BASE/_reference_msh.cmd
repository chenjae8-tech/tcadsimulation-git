Title ""

Controls {
}

IOControls {
	outputFile = "/home/dajava/Lg25/t40/NAND_base_251115/NAND_base_250907"
	EnableSections
}

Definitions {
	Constant "ConstantProfileDefinition_sd" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+20
	}
	Constant "ConstantProfileDefinition_ch" {
		Species = "BoronActiveConcentration"
		Value = 1e+17
	}
	Refinement "RefinementDefinition_1" {
		MaxElementSize = ( 0.0005 0.0005 )
		MinElementSize = ( 0.0001 0.0001 )
	}
}

Placements {
	Constant "ConstantProfilePlacement_source" {
		Reference = "ConstantProfileDefinition_sd"
		EvaluateWindow {
			Element = region ["region_1_b0"]
		}
	}
	Constant "ConstantProfilePlacement_drain" {
		Reference = "ConstantProfileDefinition_sd"
		EvaluateWindow {
			Element = region ["region_11_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch1" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_2_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch2" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_3_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch3" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_4_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch4" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_5_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch5" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_6_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch6" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_7_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch7" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_8_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch8" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_9_b0"]
		}
	}
	Constant "ConstantProfilePlacement_ch9" {
		Reference = "ConstantProfileDefinition_ch"
		EvaluateWindow {
			Element = region ["region_10_b0"]
		}
	}
	Refinement "RefinementPlacement_1" {
		Reference = "RefinementDefinition_1"
		RefineWindow = material ["Oxide"]
		RefineWindow = material ["Si3N4"]
	}
}
