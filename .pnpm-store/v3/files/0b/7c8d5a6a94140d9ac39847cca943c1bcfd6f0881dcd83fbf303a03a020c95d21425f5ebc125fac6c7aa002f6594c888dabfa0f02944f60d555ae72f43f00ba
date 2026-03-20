import { Node, RootNode, ElementNode, PlainElementNode, ComponentNode, TemplateNode, TextNode, CommentNode, SimpleExpressionNode, InterpolationNode, AttributeNode, DirectiveNode, SourceLocation } from '@vue/compiler-core';
export { AttributeNode, CommentNode, ComponentNode, DirectiveNode, ElementNode, InterpolationNode, Node, PlainElementNode, RootNode, SimpleExpressionNode, SourceLocation, TemplateNode, TextNode } from '@vue/compiler-core';

/**
 * Checks if it is a valid JavaScript identifers.
 *
 * @public
 */
declare function isSimpleIdentifier(content: string): boolean;
/**
 * Checks if it is Vue template AST Node.
 *
 * @public
 */
declare function isNode(node: unknown): node is Node;
/**
 * Checks if it is an AST RootNode.
 *
 * @public
 */
declare function isRootNode(node: unknown): node is RootNode;
/**
 * Checks if it is an AST ElementNode.
 *
 * @public
 */
declare function isElementNode(node: unknown): node is ElementNode;
/**
 * Checks if it is an AST PlainElementNode.
 *
 * @public
 */
declare function isPlainElementNode(node: unknown): node is PlainElementNode;
/**
 * Checks if it is an AST ComponentNode.
 *
 * @public
 */
declare function isComponentNode(node: unknown): node is ComponentNode;
/**
 * Checks if it is an AST TemplateNode.
 * @public
 */
declare function isTemplateNode(node: unknown): node is TemplateNode;
/**
 * Checks if it is an AST TextNode.
 * @public
 */
declare function isTextNode(node: unknown): node is TextNode;
/**
 * Checks if it is an AST CommentNode.
 * @public
 */
declare function isCommentNode(node: unknown): node is CommentNode;
/**
 * Checks if it is an AST ExpressionNode.
 * @public
 */
declare function isSimpleExpressionNode(node: unknown): node is SimpleExpressionNode;
/**
 * Checks if it is an AST InterpolationNode.
 * @public
 */
declare function isInterpolationNode(node: unknown): node is InterpolationNode;
/**
 * Checks if it is an AST AttributeNode.
 * @public
 */
declare function isAttributeNode(node: unknown): node is AttributeNode;
/**
 * Checks if it is an AST DirectiveNode.
 * @public
 */
declare function isDirectiveNode(node: unknown): node is DirectiveNode;

/**
 * Create AST Node
 *
 * @public
 */
declare function createSimpleExpression(content: SimpleExpressionNode['content'], isStatic: SimpleExpressionNode['isStatic'], loc?: SourceLocation, isConstant?: boolean): SimpleExpressionNode;

/**
 * @public
 */
declare type TraversalAncestors = Array<{
    node: Node;
    key: string;
    index?: number;
}>;
/**
 * @public
 */
declare type TraversalHandler<T> = (node: Node, ancestors: TraversalAncestors, state: T) => void;
/**
 * @public
 */
interface TraversalHandlers<T> {
    enter?: TraversalHandler<T>;
    exit?: TraversalHandler<T>;
}
/**
 * A general AST traversal utility with both prefix and postfix handlers, and a
 * state object. Exposes ancestry data to each handler so that more complex
 * AST data can be taken into account.
 *
 * @public
 */
declare function traverse<T>(node: Node, handlers: TraversalHandler<T> | TraversalHandlers<T>, state?: T): void;
/**
 * An abortable AST traversal utility. Return false (or falsy value) to stop traversal.
 *
 * @public
 */
declare function traverseEvery<T>(node: Node, enter: (node: Node, ancestors: TraversalAncestors, state: T) => boolean, state?: any, ancestors?: TraversalAncestors): void;
/**
 * A faster AST traversal utility. It behaves same as [traverse()] but there is no ancestory data.
 *
 * @public
 */
declare function traverseFast<T = any>(node: object, enter: (node: Node, state: T, stop: () => void) => void, state?: T): void;

/**
 * @public
 */
interface SearchResult {
    node: Node | null;
    ancestors: TraversalAncestors;
}
/**
 * Find the deepest node containing the given position.
 *
 * @public
 */
declare function findTemplateNodeAt(ast: RootNode, position: number): SearchResult;
/**
 * Find the parent element node.
 *
 * @public
 */
declare function findParentNode(ast: RootNode, node: Node): ElementNode | undefined;
/**
 * Find a child (element, component, text, interpolation, or comment) node containing the given position.
 *
 * @public
 * @param mode - Open/close range comparison mode:
 *  • undefined - position in [start, end]
 *  • 'start'   — position in [start, end)
 *  • 'end'     - position in (start, end]
 */
declare function findTemplateChildNodeAt(ast: RootNode, position: number, mode?: 'start' | 'end'): SearchResult;
/**
 * Find the deepest node containing the given position.
 *
 * @public
 * @param mode - Open/close range comparison mode:
 *  • undefined - position in [start, end]
 *  • 'start'   — position in [start, end)
 *  • 'end'     - position in (start, end]
 */
declare function findTemplateNodeInRange(ast: RootNode, start: number, end: number, mode?: 'start' | 'end'): SearchResult;
/**
 * Get all nodes contained in given range. (partial overlaps are ignored)
 *
 * @public
 */
declare function findTemplateNodesInRange(ast: RootNode, start: number, end: number): Node[];
/**
 * Get all child (element, component, text, interpolation, or comment) nodes contained in given range. (partial overlaps are ignored)
 *
 * @public
 */
declare function findTemplateChildrenInRange(ast: RootNode, start: number, end: number): Node[];

/**
 * @public
 */
interface StringifyOptions {
    indent: number;
    initialIndent: number;
    directive: 'shorthand' | 'longhand';
    replaceNodes: Map<Node, Node | null>;
}
/**
 * Convert template AST to template code.
 *
 * @public
 */
declare function stringify(node: Node | Node[], options?: Partial<StringifyOptions>): string;

export { SearchResult, StringifyOptions, TraversalAncestors, TraversalHandler, TraversalHandlers, createSimpleExpression, findParentNode, findTemplateChildNodeAt, findTemplateChildrenInRange, findTemplateNodeAt, findTemplateNodeInRange, findTemplateNodesInRange, isAttributeNode, isCommentNode, isComponentNode, isDirectiveNode, isElementNode, isInterpolationNode, isNode, isPlainElementNode, isRootNode, isSimpleExpressionNode, isSimpleIdentifier, isTemplateNode, isTextNode, stringify, traverse, traverseEvery, traverseFast };
