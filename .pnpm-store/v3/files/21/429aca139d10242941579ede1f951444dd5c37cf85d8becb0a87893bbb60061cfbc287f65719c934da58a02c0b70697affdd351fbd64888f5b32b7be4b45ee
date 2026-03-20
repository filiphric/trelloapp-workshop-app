# eslint-html-parser

Custom ESLint parser for HTML files that falls back to using [espree](https://github.com/eslint/espree) or another JavaScript parser for `.js` and `.jsx` files and for `<script>` tags within the HTML.

## Installation

```terminal
$ npm install --save-dev eslint eslint-html-parser
```

- Requires Node.js 6.x or later
- Requires ESLint 5.x or later

## Usage

1. Add the `parser` option to your `.eslintrc.*` file.
2. Use glob patterns or the `--ext` CLI option

```json
{
    "parser": "eslint-html-parser"
}
```

```terminal
$ eslint "src/**/*.{js,htm,html}"
# or
$ eslint --ext .htm --ext .html --ext .js src
```

## Options

Within your `.eslintrc.*` file, the `parserOptions` property supports the same options as [espree](https://github.com/eslint/espree#usage).  For example:

```json
{
    "parser": "eslint-html-parser",
    "parserOptions": {
        "sourceType": "module",
        "ecmaVersion": 2018,
        "ecmaFeatures": {
            "globalReturn": false,
            "impliedStrict": false,
            "jsx": false
        }
    }
}
```

The only additional option under `parserOptions` is `parser`, which specifies the JavaScript parser that `eslint-html-parser` will fall back to in order to parse JavaScript.  This option defaults to `espree`.

## Usage for custom rules/plugins

HTML files are parsed into an AST, which can be traversed, examined, and linted with the visitor pattern like any other ESLint source.  The HTML AST that is produced has the following types of nodes and structure:

- HTMLElement
  - tagName: string
  - parent: HTMLElement
  - attributes: HTMLAttribute[]
  - children: (HTMLElement | HTMLText | HTMLWhitespace | HTMLComment)[]

- HTMLAttribute
  - parent: HTMLElement
  - attributeName: HTMLAttributeName
  - attributeValue: HTMLAttributeValue

- HTMLAttributeName
  - parent: HTMLAttribute
  - value: string

- HTMLAttributeValue
  - parent: HTMLAttribute
  - value: string

- HTMLText
  - parent: HTMLElement
  - value: string

- HTMLWhitespace
  - parent: HTMLElement
  - value: string

- HTMLComment
  - parent: HTMLElement
  - text: string

- HTMLProcessingInstruction
  - target: string
  - data: string

**Note:** The `children` property for `HTMLElement` nodes for `<script>` tags will contain the AST resulting from parsing the script's text.