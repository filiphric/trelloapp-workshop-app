/// <reference types="cypress" />
import { InlineConfig } from 'vite';
import { StartDevServerOptions } from './startServer';
export { StartDevServerOptions };
export declare function startDevServer(startDevServerArgs: StartDevServerOptions): Promise<Cypress.ResolvedDevServerConfig>;
export declare type CypressViteDevServerConfig = Omit<InlineConfig, 'base' | 'root'>;
export declare function devServer(cypressDevServerConfig: Cypress.DevServerConfig, devServerConfig?: CypressViteDevServerConfig): Promise<Cypress.ResolvedDevServerConfig>;
export declare function defineDevServerConfig(devServerConfig: CypressViteDevServerConfig): CypressViteDevServerConfig;
