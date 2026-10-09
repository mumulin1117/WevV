import eslint from '@eslint/js'
import prettier from 'eslint-config-prettier'
import vue from 'eslint-plugin-vue'
import globals from 'globals'
import tseslint from 'typescript-eslint'

export default tseslint.config(
  {
    ignores: [
      'dist/**',
      'native/**/WebApp/**',
      'test-projects/**',
      'src/types/components.d.ts',
      'src/retained-local/content/**',
    ],
  },
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  ...vue.configs['flat/recommended'],
  {
    languageOptions: {
      ecmaVersion: 'latest',
      globals: { ...globals.browser, ...globals.node },
      parserOptions: {
        extraFileExtensions: ['.vue'],
        parser: tseslint.parser,
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      '@typescript-eslint/consistent-type-imports': ['error', { fixStyle: 'inline-type-imports' }],
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
      ],
      curly: ['error', 'multi-line'],
      eqeqeq: ['error', 'always'],
      'no-console': ['error', { allow: ['warn', 'error'] }],
      'vue/block-order': ['error', { order: ['script', 'template', 'style'] }],
      'vue/component-api-style': ['error', ['script-setup']],
      'vue/component-name-in-template-casing': [
        'error',
        'PascalCase',
        { registeredComponentsOnly: false },
      ],
      'vue/html-indent': ['error', 2],
      'vue/max-attributes-per-line': ['error', { multiline: 1, singleline: 3 }],
      'vue/multi-word-component-names': 'off',
      'vue/singleline-html-element-content-newline': 'off',
    },
  },
  {
    files: ['**/*.mjs', '**/*.cjs', '**/*.mts'],
    languageOptions: { parserOptions: { projectService: false } },
  },
  {
    files: ['scripts/**/*.{mjs,cjs}'],
    rules: { 'no-console': 'off' },
  },
  {
    files: ['src/core/bridge/**/*.ts', 'src/env.d.ts'],
    rules: { '@typescript-eslint/no-explicit-any': 'off' },
  },
  {
    files: ['src/core/navigation/types.ts'],
    rules: { '@typescript-eslint/no-empty-object-type': 'off' },
  },
  {
    files: [
      'src/**/components/**/*.{ts,vue}',
      'src/**/pages/**/*.{ts,vue}',
      'src/room/RoomApp.vue',
    ],
    rules: {
      'no-restricted-globals': [
        'error',
        { message: '视图层通过 domain service/action/query 请求数据。', name: 'fetch' },
      ],
      'no-restricted-imports': [
        'error',
        {
          paths: [
            { message: '视图层不得直接导入 Axios。', name: 'axios' },
            { message: '视图层通过领域 service 使用 ApiClient。', name: '@/core/api/client' },
          ],
        },
      ],
    },
  },
  {
    files: ['src/main/components/AppSafeRichText.vue'],
    rules: { 'vue/no-v-html': 'off' },
  },
  prettier,
)
