# 代码格式化流程

本次介绍：`Prettier`，`commitlint`

## Rrettier

```bash
// 安装perttier
npm install prettier --save-dev --save-exact
```

项目根目录新建`.prettierrc.json`文件添加 Prettier 配置

```json
//例子
"prettier": {
    "printWidth": 80,
    "tabWidth": 2,
    "useTabs": false,
    "singleQuote": true,
    "semi": true,
    "trailingComma": "all"
  }
```

项目根目录新建`.prettierrcignore`文件添加 Prettier 过滤名单配置

```
# Ignore artifacts:
dist
coverage
```

配置工程的`settings.json`
在工程根目录下创建`.vscode`目录，在`.vscode`中创建`settings.json`文件，写入以下内容：

```json
{
	"[vue]": {
		"editor.defaultFormatter": "esbenp.prettier-vscode"
	},
	"[jsonc]": {
		"editor.defaultFormatter": "esbenp.prettier-vscode"
	},
	"[typescript]": {
		"editor.defaultFormatter": "esbenp.prettier-vscode"
	},
	"[json]": {
		"editor.defaultFormatter": "esbenp.prettier-vscode"
	},
	"[javascript]": {
		"editor.defaultFormatter": "esbenp.prettier-vscode"
	},
	"javascript.updateImportsOnFileMove.enabled": "always",
	"editor.formatOnSave": true,
	"window.zoomLevel": 0,
	"files.eol": "\n"
}
```

## 配置 Pre-commit Hook

在代码`commit`前，对处于`staged`状态下的文件进行一次格式化，避免提交的格式不符合要求。 在项目根目录执行：

```bash
npx mrm@2 lint-staged
```

命令执行完成后会自动安装`husky`和`lint-staged`依赖。并创建`.husky`目录，查看`package.json`文件是否添加相应配置：

```json
"lint-staged": {
    "*.{js,css,md,ts,tsx,vue}": "prettier --write"
  }
```

### 配置 commitlint

接着我们开始配置`commitlint`来规范`commit`提交的信息

安装依赖

```bash
npm install -g @commitlint/cli @commitlint/config-conventional --save-dev
```

在项目根目录新建配置文件`commitlint.config.js`，写入以下内容：

```js
module.exports = {
	extends: ["@commitlint/config-conventional"],
};
```

在`.husky`目录下新增文件`commit-msg`，写入以下内容：

```shell
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx --no-install commitlint --edit $1
```

注意：

- `package.json`，type 参数值不能为`moudle`
- `commitlint.config.js`文件编码格式需要为`utf-8`
