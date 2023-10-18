/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  i18n: {
    locales: ["en-gb"],
    defaultLocale: "en-gb",
  },
}

module.exports = nextConfig
