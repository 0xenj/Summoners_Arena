"use client";

import "./globals.css";
import Header from "../components/Header";
import AppProvider from "../context/AppContext";

export default function MyApp({ Component, pageProps }) {
  return (
    <AppProvider>
      <Header />
      {/* <Component {...pageProps} /> */}
    </AppProvider>
  );
}
