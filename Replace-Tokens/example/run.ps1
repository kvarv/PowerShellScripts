$base_dir = resolve-path .\..
$example_dir = "$base_dir\example"
. $base_dir\Replace-Tokens.ps1


replace_tokens_with_file "$example_dir\some.data.ps1" "$example_dir\some.template" "$example_dir\output.txt" true