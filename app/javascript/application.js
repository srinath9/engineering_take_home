// Entry point for the build script in your package.json
import React from 'react';
import ReactDOM from 'react-dom';
import HelloWorld from './components/HelloWorld';
import App from "./components/App";

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('react-root');
  if (node) {
    ReactDOM.render(<App />, node);
  }
});
