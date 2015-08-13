# What? #

An AS3 dynamic, recursive descent (predictive) parser generator for LL(k) non-left-recursive grammars with AST and XML generation facilities.

Something along the lines of http://spirit.sourceforge.net/, only way simpler.

You should be able to define grammars using plain strings and generate a ready to use parser at runtime.

While it won't really be powerful, performant or memory-friendly in the beginning, it should help you create and use small [DSLs](http://uiblog.aldobucchi.com/2008/06/domain-specific-languages-in-as3-part-1.html) if you wish to do so without resorting to more complex tools such as [ANTLR](http://www.antlr.org/) et Al.


# Status #

This project is currently being ported from an old codebase. So be patient.

You can browse the source and you will find that there is a lot in place, but it will take some time before you can actually use this in your projects. While it did work before, in the porting process I had to strip off some proprietary dependencies which broke some parts of the framework.

The main developer has very little time and will do its best to keep up or, better yet, recruit collaborators.

You are more than welcome to contribute in any way you want.


# Roadmap #

  * Batch parser ( not incremental )
  * Batch Workbench ( to help you debug your grammars )
  * Base grammars ( contribute [here](http://code.google.com/p/flashlr/source/browse/trunk/FlashLR/src/com/googlecode/flashlr/grammar/lib/) ( W3C EBNF Syntax ) )
  * Performance and Memory improvements
    * Pooling model objects, tokens, etc
    * Tweaking algorithms
    * Splitting processing into large chunks ( async )
  * ( 2 years of vacation )
  * Incremental parsing






# History #

Aldo says:

The seed code came from an old project where I needed to create a large amount of simple parsers ( semweb and KR&R stuff ). Performance was not an issue and the whole thing was built in less than a week. So don't expect much.
However, I think the layout is sufficiently clean and something more powerful can be built on top... that's why I decided to open it.
If you have any students learning compiler theory please point them this way. There is no better way to learn than by getting your hands dirty.
And there is no better way to get dirty than... well, you get the point.






# Design #

## Architecture ##

The framework is split in modules
  * [grammar](http://code.google.com/p/flashlr/source/browse/trunk/FlashLR/src/com/googlecode/flashlr/grammar/)
  * [scanner](http://code.google.com/p/flashlr/source/browse/trunk/FlashLR/src/com/googlecode/flashlr/scanner/)
  * [parser](http://code.google.com/p/flashlr/source/browse/trunk/FlashLR/src/com/googlecode/flashlr/parser/)

Each module communicates with the next through an abstract representation of the output, effectively creating a complete parsing pipeline.


## Syntax ##
There will be a different syntax for Terminals and Non-Terminals

### Terminals ###
It makes sense to use standard ECMA regular expression syntax ( flex developers are used to it ). There is only one addition to enable recursive inclusion of other terminal rules: {{ruleName}}. This is just syntactic sugar. The referenced rule will be replaced by its expression at runtime.

Some examples:
( Note that all expressions are, by default, in eXtended mode )
```
DECIMAL               ::=       [0-9]+ \. [0-9]* | \. [0-9]+
DOUBLE                ::=       [0-9]+ \. [0-9]* {{EXPONENT}} | \. ([0-9])+ {{EXPONENT}} | ([0-9])+ {{EXPONENT}}
INTEGER_POSITIVE      ::=       \+ {{INTEGER}}
DECIMAL_POSITIVE      ::=       \+ {{DECIMAL}}
DOUBLE_POSITIVE       ::=       \+ {{DOUBLE}}
INTEGER_NEGATIVE      ::=       \- {{INTEGER}}
DECIMAL_NEGATIVE      ::=       \- {{DECIMAL}}
DOUBLE_NEGATIVE       ::=       \- {{DOUBLE}}
EXPONENT              ::=       [eE] [+-]? [0-9]+
```

One really neat feature is that you will be able to query the generated Token for any subpattern ( including nested Terminal Rules ).

### Non-Terminals ###

Non terminals are written in the W3C EBNF syntax:

```
Query             ::=       Prologue ( SelectQuery | ConstructQuery | DescribeQuery | AskQuery )
Prologue          ::=       BaseDecl? PrefixDecl*
BaseDecl          ::=       'BASE' IRI_REF
PrefixDecl        ::=       'PREFIX' PNAME_NS IRI_REF
SelectQuery       ::=       'SELECT' ( 'DISTINCT' | 'REDUCED' )? ( Var+ | '*' ) DatasetClause* WhereClause SolutionModifier
ConstructQuery    ::=       'CONSTRUCT' ConstructTemplate DatasetClause* WhereClause SolutionModifier
DescribeQuery     ::=       'DESCRIBE' ( VarOrIRIref+ | '*' ) DatasetClause* WhereClause? SolutionModifier
AskQuery          ::=       'ASK' DatasetClause* WhereClause
DatasetClause     ::=       'FROM' ( DefaultGraphClause | NamedGraphClause )
```

They are compiled at runtime into a Recursive Descent ( predictive ) parser. Lazy quantifiers are not currently supported ( they are not part of normal EBNF anyway ).

## Workflow ##

Basic workflow is as follows:

  * Create a Grammar object to hold all rule declarations
  * Declare Terminals and Non-Terminals
  * Compile the Grammar to generate the Scanner and the ParserModel
    * You won't be able to add any more rules after compiling a Grammar
    * Basic error checking is performed at this point
      * For Terminals: Recursion is not allowed ( they are internally compiled to '''regular''' expressions, remember )
      * For Non-Terminals: Left Recursion is not allowed. If this happens, consider rewriting you grammar to eliminate left-recursion
  * You can now use the scanner and Parser Model ( along with a a parser evaluator ) as many times as you like with zero compiling overhead


## Brainstorming ##

### Scanner ###

The Scanner produces a list of tokens. Tokens can be added, removed, replaced, and their image ( matched string ) can also change.

The parser that works on this TokenList is actively listening to any changes and can react in an optimal way, minimizing the changes to the syntactic structure.

Some optimizations:

  * If a Token changes its image, no Syntactic change is performed
  * If a Token is removed, the nearest enclosing parse node must evaluate if the removal triggers a change ( hopefully not )
  * If a Token is added at a given index, and this falls within a given parsenode's match domain, the parse node must evaluate if a change has happened ( changes are propagated upwards, and catched by the closest unchanged upstream node ).

When the user edits a certain point ( removing or adding chars ), the relevant Token is retrieved and its regex is run in isolation starting at that given index. If there is no match, then the scanner is re-run from that point onwards. If there is a match, and the length delta ( against the original match ) corresponds to the previous match plus the edition delta, then we assume that the token is still valid and only its image is changed. Nothing else changes in the list.

Above all these optimizations, there is a TouchTimer queueing strategy to allow for multiple edits.

The index in a Token is a calculated property. It is calculated on-demand based on the length of all the previous tokens. This operation is cached when possible to allow for optimization.


### Parser ###

Quantifiers

Non-Greedy quantifiers must go up to the nearest enclosing sequence and inform of its possible completeness indexes. All of these will create new alternative parse trees that cannot be discarded until the full sequence matches.

Greedy quantifiers, on the other hand, will inform of only one possible match. They can, however, inform that a match occurred at a previous index ( the last match failed ), so the sequence has to rewind its token stream

Quantifier informs the nearest enclosing sequence that a possible match index has been reached.
Sequence creates a new Sequence Alternative node branches the current parse tree into alternatives, and keeps on pushing tokens down the current node PLUS a new node where the sequence has been advanced.

when there is a stream rewind, a small amount of tokens are set in a buffer... they are automatically "pushed" down again once the evaluation re-starts



#### Alternative parse trees ####

Parse trees also branch in the "alternative" axis. This happens in two situations:
  * OR nodes will produce an automatic binary branching. The two alternatives are kept alive until they fail. The longest match wins. If both fail, then the OR node fails.

  * Quantifiers will produce an alternative branching in their nearest enclosing sequence node every time they complete a match. These alternatives have different lifecycles, depending on the "greediness" of the quantifier.
  * In greedy nodes, each new alternative is kept alive until there is a new quantifier match or until the quantifier sends the "keep latest match" message, which means that a new match was not possible. If the quantifier creates a new match and reaches its maximum, then a "final match" message is sent upstream.

  * Alternative branching is handled by alternative branching nodes. These nodes react to messages coming upstream and know how to create an alternative. Each new branch starts off as a clone of the original node. Branching nodes propagate token pointers downstream to each active alternative. Alternatives become inactive if they have failed.

Quantifier Branching

  * Quantifier starts with only one child node
  * Once this child node completes a match, the Quantifier advances
    * If it reached its max, then it declares itself complete
    * Otherwise, a branching is required
  * The Quantifier sends an upstream message requesting branching
  * This message is received by the nearest enclosing sequence
  * The message also specifies whether the quantifier is Greedy or not ( this is important info for the sequence )
  * Sequence requests its branching node ( above ) to create a new branch. In one of these branches the sequence advances and creates its right child node. In the other, the sequence remains at the left child node.






