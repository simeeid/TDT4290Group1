This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/basic-features/font-optimization) to automatically optimize and load Inter, a custom Google Font.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.

## Using the Dockerfile

The dockerfile creates a standard environment for running the app. The dockerfile is based on Debian with Node.js 20, using the official Node.js image.

There are two different modes, which is specified at image build time. By default, the image is built in production mode, meaning it runs `npm run build && npm run start`. The image can be built in development mode instead, which runs `npm run dev` instead.

Example commands:
```
cd norbit-webapp
# Option 1: dev mode
docker build --build-arg BUILD_MODE=dev -t norbit .
# Option 2: production mode
docker build -t norbit . 

docker run -p 3000:3000 --rm -ti norbit
```
(the exact name is not important; you can pick a different name, particularly if you're running both debug and production containers on the same system)

Note that in neither case does it sync the source tree into the docker container. Due to limitations of how volumes are mounted, filesystem update information [is discarded][docker-volume-info-discard], meaning `npm run dev` doesn't pick up file changes. Using the dockerfile for development therefore requires a rebuild of the dockerfile for all changes. It's recommended to create a copyable command for reuse for development instead, or running locally.

[docker-volume-info-discard]: https://forums.docker.com/t/docker-compose-not-synchronising-file-changes-in-volume/79177/4

## Running tests

There are three different types of  tests spread across two different libraries. Unit tests are managed by jest, while component and integration tests are handled by cypress.

### Running all tests
**Note:** This step requires bash. To run on Windows, you can use Git Bash, or optionally WSL with configuration this document won't cover. You can always run the tests separately manually, as outlined in the next two sections.

There's a convenience script for running all the tests. With `norbit-webapp` as the working directory, run `./scripts/test.sh`. This will automatically run the unit and component tests, and then spin up a server and run the integration tests. You can also type `./scripts/test.sh dev` to use a dev environment instead of a production environment, or `./scripts/test.sh skip-server` to not start the server.

The latter is particualrly useful if you have `npm run dev` running elsewhere for debugging.

Note that `npm run dev`/`npm run start` must NOT be running elsewhere before 

### Running unit tests

Run `npm run unit-test`

### Running Cypress

The Cypress tests can be run interactively with `npm run cypress`. 

Cypress doesn't let you run two the two types of tests at once with any command. However, this isn't as obvious when running interactively, as the two are separated in the UI in a way that's logical for UX as well.

Consequently, running the tests manually requires running two commands. These are covered in the subsections.

#### Component tests

To run component tests, use `npm run component-test`. 

Component tests are comparatively self-contained; Cypress spawns a dummy server it renders the components in, and does whatever test stuff on it there. No further outside intervention is needed to get the tests to cooperate.

#### Integration tests

Note: the integration tests require the server to run separately. You can run it with `npm run build && npm run start`, or `npm run dev` in a separate terminal tab prior to running the tests. As long as the server is on port `:3000`, Cypress will connect and run.

When the server is up, you can use `npm run integration-test` to run the tests.

As long as the server is running, to run all tests at once, you can use `npm run unit-test && npm run component-test && npm run integration-test` to run all the tests in a single command.
