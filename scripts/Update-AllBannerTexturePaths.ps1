$textureMapping = @{
    "mosaic_complex_braid" = @{
        "metal" = "ground_celtic_complex_braid_01x01_metal_0.png"
        "diff" = "ground_celtic_complex_braid_01x01_diff_0.png"
        "norm" = "ground_celtic_complex_braid_01x01_norm_0.png"
    }
    "mosaic_interlace_knot" = @{
        "metal" = "ground_celtic_interlace_knot_01x01_metal_0.png"
        "diff" = "ground_celtic_interlace_knot_01x01_diff_0.png"
        "norm" = "ground_celtic_interlace_knot_01x01_norm_0.png"
    }
    "mosaic_mirrored_braid" = @{
        "metal" = "ground_celtic_mirrored_braid_01x01_metal_0.png"
        "diff" = "ground_celtic_mirrored_braid_01x01_diff_0.png"
        "norm" = "ground_celtic_mirrored_braid_01x01_norm_0.png"
    }
    "mosaic_triquetra" = @{
        "metal" = "ground_celtic_triquetra_01x01_metal_0.png"
        "diff" = "ground_celtic_triquetra_01x01_diff_0.png"
        "norm" = "ground_celtic_triquetra_01x01_norm_0.png"
    }
    "mosaic_triskelion" = @{
        "metal" = "ground_celtic_triskelion_01x01_metal_0.png"
        "diff" = "ground_celtic_triskelion_01x01_diff_0.png"
        "norm" = "ground_celtic_triskelion_01x01_norm_0.png"
    }
    "mosaic_interlocking_diamond" = @{
        "metal" = "ground_interlocking_diamond_01x01_metal_0.png"
        "diff" = "ground_interlocking_diamond_01x01_diff_0.png"
        "norm" = "ground_interlocking_diamond_01x01_norm_0.png"
    }
    "mosaic_roset" = @{
        "metal" = "ground_roset_1x1_metal_0.png"
        "diff" = "ground_roset_1x1_diff_0.png"
        "norm" = "ground_roset_1x1_norm_0.png"
    }
    "mosaic_spiral" = @{
        "metal" = "ground_spiral_01x01_metal_0.png"
        "diff" = "ground_spiral_01x01_diff_0.png"
        "norm" = "ground_spiral_01x01_norm_0.png"
    }
}

$metalNode = "\<cModelMetallicTex\>(.*)\<\/cModelMetallicTex\>"
$diffNode = "\<cModelDiffTex\>(.*)\<\/cModelDiffTex\>"
$normNode = "\<cModelNormalTex\>(.*)\<\/cModelNormalTex\>"

$workFolder = "$($PSScriptRoot)\..\src\data\mrr0b3rt\graphics\roman\buildings\ornaments\grounds\mosaic_plazas"
$mapsPath = "data/mrr0b3rt/graphics/roman/buildings/ornaments/grounds/mosaic_plazas/maps"

Get-ChildItem $workFolder -Exclude maps | % { 
    Write-Output "# Processing '$($_.Name)'"
    $tileName = $_.Name
    $cfgFiles = Get-ChildItem $($_.FullName) -Recurse -Filter *.cfg

    foreach( $cfg in $cfgFiles ) {
        Write-Output "-- cfg file '$($cfg.FullName)'"

        $cfgContent = Get-Content $cfg.FullName -Raw

        if( $cfgContent -match $metalNode ) {
            Write-Output "[OLD] $($Matches[0])"

            $newNode = "<cModelMetallicTex>$($mapsPath)/$($textureMapping[$tileName].metal)</cModelMetallicTex>"
            Write-Output "[NEW] $($newNode)"
            $cfgContent = ($cfgContent -replace $Matches[0],$newNode)
        }
        else {
            Write-Warning "Unable to find metal node"
        }

        if( $cfgContent -match $diffNode ) {
            Write-Output "[OLD] $($Matches[0])"

            $newNode = "<cModelDiffTex>$($mapsPath)/$($textureMapping[$tileName].diff)</cModelDiffTex>"
            Write-Output "[NEW] $($newNode)"
            $cfgContent = ($cfgContent -replace $Matches[0],$newNode)
        }
        else {
            Write-Warning "Unable to find diff node"
        }

        if( $cfgContent -match $normNode ) {
            Write-Output "[OLD] $($Matches[0])"

            $newNode = "<cModelNormalTex>$($mapsPath)/$($textureMapping[$tileName].norm)</cModelNormalTex>"
            Write-Output "[NEW] $($newNode)"
            $cfgContent = ($cfgContent -replace $Matches[0],$newNode)
        }
        else {
            Write-Warning "Unable to find norm node"
        }

        $cfgContent | Set-Content $cfg.FullName
    }

    Write-Output "### DONE ###"
}