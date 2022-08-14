# 背景

在项目开发的协同工作中，由于每个人的编码爱好以及编码风格不同，很容易出现提交的代码在合并的过程中风格不统一诸如空格缩进，单引号双引号，一行多少个字符，结尾是否有`:`等情况。综上所述，项目的统一风格显得尤为重要。

# 代码格式化流程

本次介绍：`Prettier`，`commitlint`

## Prettier

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
在工程根目录下创建`.vscode`目录，在`.vscode`中创建`settings.json`文件，此文件会覆盖默认`vscode`编码配置，并且根据参数值对相应文件进行监听，写入以下内容：

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

使用`commitlint + husky` 规范 `git commit -m ""` 中的描述信息。在代码`commit`前，对处于`staged`状态下的文件进行一次格式化，避免提交的格式不符合要求。 在项目根目录执行：

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

#### 安装

安装依赖

```bash
npm install -g @commitlint/cli @commitlint/config-conventional --save-dev
```

在项目根目录新建配置文件`commitlint.config.js`，写入以下内容：

```js
module.exports = {
	extends: ['@commitlint/config-conventional'],
};
```

在`.husky`目录下新增文件`commit-msg`，写入以下内容：

```shell
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx --no-install commitlint --edit $1
```

####使用
提交规范

```bash
git commit -m <type>[optional scope]: <description>
```

常用的 type 类型
`<type>` ：根据你本次代码对项目做出何种相应变化，总结以下 11 种类型：

- build：主要目的是修改项目构建系统(例如 glup，webpack，rollup 的配置等)的提交
- ci：主要目的是修改项目继续集成流程(例如 Travis，Jenkins，GitLab CI，Circle 等)的提交
- docs：文档更新
- feat：新增功能
- fix：bug 修复
- perf：性能优化
- refactor：重构代码(既没有新增功能，也没有修复 bug)
- style：不影响程序逻辑的代码修改(修改空白字符，补全缺失的分号等)
- test：新增测试用例或是更新现有测试
- revert：回滚某个更早之前的提交
- chore：不属于以上类型的其他类型(日常事务)

`[optional scope]`：一个可选的修改范围。用于标识此次提交主要涉及到代码中哪个模块。
`<description>`：用自己的话适当描述本次代码提交的内容和意图。

注意：

- `package.json`，type 参数值不能为`moudle`
- `commitlint.config.js`文件编码格式需要为`utf-8`
