/// <reference types="cypress" />
import { ViteDevServer, InlineConfig } from 'vite';
export interface StartDevServerOptions {
    /**
     * the Cypress dev server configuration object
     */
    options: Cypress.DevServerConfig;
    /**
     * By default, vite will use your vite.config file to
     * Start the server. If you need additional plugins or
     * to override some options, you can do so using this.
     * @optional
     */
    viteConfig?: Omit<InlineConfig, 'base' | 'root'>;
}
export declare function start(devServerOptions: StartDevServerOptions): Promise<ViteDevServer>;
