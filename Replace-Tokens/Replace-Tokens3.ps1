function global:Replace-Tokens($data_file, $template_file, $output_file) {
    
	Test-ExistenceOfFiles $data_file $template_file $output_file

	$template_data = Get-Content $data_file
	$data_values = Read-Data $template_data
	$data_values = Add-GlobalValues $data_values
	
	$template_text = Get-Content $template_file  | Out-String

	foreach ($item in $data_values.Keys) {
		$template_text = $template_text -replace "#{$item}", $data_values.Get_Item($item).Trim()  
	}
	
	$output_dir = Split-Path $output_file
	if (!(Test-Path $output_dir)) {
		mkdir $output_dir  -ErrorAction SilentlyContinue  | out-null
	}
	
	$template_text | Set-Content -path $output_file
}

function Read-Data($template_data){
	$data_values = @{}
	foreach($line in $template_data) {
		$data = $line.Split(":")
		$key = $data[0].Trim()
		$data = @($data | Where-Object {$_ -ne $data[0]})
		$data_values.add($key , [string]::join(":", $data).Trim())       
	}
	return $data_values
}

function Test-ExistenceOfFiles($data_file, $template_file, $output_file){
	if (!$data_file) {
		throw "Path to template data file was not provided"        
	}
	if (!(Test-Path $data_file)) {
		throw "Template data file could not be found --" + $data_file
	}
	if (!$template_file) { 
		throw "Path to template file was not provided"        
	}
	if (!(Test-Path $template_file)) {
		throw "Template file could not be found --" + $template_file
	}
	if (!$output_file) {
		throw "Output file was not provided"        
	}
}

function Add-GlobalValues($data_values) {
	if($data_values.ContainsKey("@include")){
		$global_data_dir = Split-Path $data_file
		$global_data_path = Join-Path $global_data_dir $data_values["@include"]
		
		if (Test-Path $global_data_path) {
			$global_data = Get-Content $global_data_path
			$global_values = Read-Data $global_data
			$data_values = $data_values + $global_values
			$data_values.remove("@include")
			return $data_values
		}
		else { 
			throw "Data file has include directive, but file was not found"        
		}
	}
}