call npm install prettier --save-dev --save-exact
copy styleguide\.prettierignore .prettierignore
copy styleguide\.prettierrc.json .prettierrc.json
xcopy styleguide\.vscode .vscode\ /y 
call npx mrm@2 lint-staged
call npm install -g @commitlint/cli @commitlint/config-conventional --save-dev
copy styleguide\commitlint.config.js commitlint.config.js
copy styleguide\commit-msg .husky\commit-msg
