function global:replace_tokens_with_file($data_file, $template_file, $output_file) {
	Test-ExistenceOfFiles $data_file $template_file $output_file
	Replace-Values (. $data_file)
}

function Replace-Values($data_values) {
	$template_text = Get-Content $template_file

	foreach ($item in $data_values.Keys) {
		$template_text = $template_text -replace "#{$item}", $data_values.Get_Item($item).Trim()
	}
	
	$output_dir = Split-Path $output_file
	if (!(Test-Path $output_dir)) {
		mkdir $output_dir  -ErrorAction SilentlyContinue  | out-null
	}
	
	$template_text > $output_file
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