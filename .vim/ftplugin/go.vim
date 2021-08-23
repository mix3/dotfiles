set noexpandtab
set tabstop=4
set shiftwidth=4

au BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])
