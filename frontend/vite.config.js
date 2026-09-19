import { defineConfig, loadEnv } from 'vite'; // 1. Import loadEnv
import react from '@vitejs/plugin-react';
import path from 'path';

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  // 2. Load env variables based on the current mode (development, production, etc.)
  // The third argument '' loads all env variables regardless of the VITE_ prefix
  const env = loadEnv(mode, process.cwd(), '');

  return {
    plugins: [react()],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
        '@components': path.resolve(__dirname, './src/components'),
        '@pages': path.resolve(__dirname, './src/pages'),
        '@hooks': path.resolve(__dirname, './src/hooks'),
        '@utils': path.resolve(__dirname, './src/utils'),
        '@store': path.resolve(__dirname, './src/store'),
        '@services': path.resolve(__dirname, './src/services'),
        '@assets': path.resolve(__dirname, './src/assets'),
        '@styles': path.resolve(__dirname, './src/styles')
      }
    },
    server: {
      port: 3000,
      host: true,
      proxy: {
        '/api': {
          // 3. Use the loaded env object with a proper object colon (:)
          target: env.VITE_API_URL || 'http://localhost:5000',
          changeOrigin: true,
          secure: false
        }
      }
    },
    build: {
      outDir: 'dist',
      sourcemap: true,
      rollupOptions: {
        output: {
          manualChunks: {
            vendor: ['react', 'react-dom', 'react-router-dom'],
            redux: ['@reduxjs/toolkit', 'react-redux', 'redux-persist'],
            ui: ['framer-motion', 'react-icons', 'react-hot-toast'],
            stripe: ['@stripe/stripe-js', '@stripe/react-stripe-js']
          }
        }
      },
      chunkSizeWarningLimit: 1000
    },
    optimizeDeps: {
      include: [
        'react',
        'react-dom',
        'react-router-dom',
        '@reduxjs/toolkit',
        'react-redux',
        'axios',
        '@stripe/stripe-js',
        '@stripe/react-stripe-js'
      ]
    },
    define: {
      global: 'globalThis'
    }
  };
});
