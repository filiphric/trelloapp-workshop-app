/// <reference types="cypress" />
import { ScrollBehaviorOptions, Position } from "../getCypressElementCoordinates";
export interface realMouseUpOptions {
    /** Pointer type for realMouseUp, if "pen" touch simulated */
    pointer?: "mouse" | "pen";
    /**
     * Position of the realMouseUp event relative to the element
     * @example cy.realMouseUp({ position: "topLeft" })
     */
    position?: Position;
    /**
     * Controls how the page is scrolled to bring the subject into view, if needed.
     * @example cy.realMouseUp({ scrollBehavior: "top" });
     */
    scrollBehavior?: ScrollBehaviorOptions;
}
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realMouseUp(subject: JQuery, options?: realMouseUpOptions): Promise<JQuery<HTMLElement>>;
