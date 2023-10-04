import { defineConfig } from 'cypress'

export default defineConfig({
  component: {
    devServer: {
      framework: 'next',
      bundler: "webpack"
    },
    specPattern: "tests/cypress/component/**/*.cy.tsx",
    supportFile: "tests/cypress/support/component.tsx",
    indexHtmlFile: 'tests/cypress/support/component-index.html'
  },
  e2e: {
    baseUrl: 'http://localhost:3000',
    specPattern: "tests/cypress/integration/**/*.cy.tsx",
    supportFile: false,
  },
  fixturesFolder: "tests/cypress/fixtures",
});
