---
layout: archive
author_profile: true
header:
  overlay_image: /assets/splash/header.png
title: "Mathematics!"
---
As an enthusiast of mathematics, I explore various mathematical concepts that captivate me. My studies at the University of Plymouth, where I am pursuing a BSc (Hons) in Computer Science with a focus on Artificial Intelligence, often intertwine with my mathematical interests. Recently, I've been creating an efficient <a href="https://github.com/alfie-ns/1003-CW" target="_blank" style="color: #448c88">`C# AVL tree`</a>`, for my university coursework, which any  can run quickly with .NET SDK, to quickly and easily see a mathamatically intresting yet complex search algorithm in action. The program will print a visual representation of the `<a href="https://en.wikipedia.org/wiki/AVL_tree" target="_blank" style="color: #448c88">AVL tree</a>` structured with box-drawing characters and necessary indentation, by quickly running ./AVL-run.sh in the terminal. This project showcases a very mathmatical complex search algorithm. Printing visually depth-first from the top-down of the root node, like so:

```
            -------------------------------------------------------------------------------------
            | DFS Traversal logic to print box-drawing structured tree: |                       | 
            -------------------------------------------------------------                       |
            |                                                                                   |   
            |                                                                                   |
            |     Consider my AVL binary tree as follows:                                       |
            |     {                                                                             |
            |            4            an AVL binary tree is a tree data structure where the     |
            |           /  \          left child or any given node is less than parent while    |
            |          2     6        while right child is >right-child. Thus a function        |
            |         / \   / \       can traverse the tree more efficiently due to the boolean |
            |        1   3 5   7      constraint used in searching instead of searching whole   |
            |                         datasets                                                  |                                                                       
            |     }                                                                             |
            |                                                                                   |
            |     Using box-drawing characters and indentation, the output would                |
            |     be:                                                                           |                                                                          
            |     {                                                                             |
            |         └─4                                                                       |
            |           ├─2         note the box-drawing tree is indeed structured depth-first  |
            |           | ├─1       ensuring each node and its children are visited before      |  
            |           | └─3       moving on, and stuctured top-down to visually represent     |      
            |           └─6         the hierarchy                                               |        
            |             ├─5                                                                   |
            |             └─7  7(last)'s indent(6->7) accumulation used next call is NOT used   |                     |
            |     }                                                                             |
            |                                                                                   |
            |     In a depth-first AVL algorithm (DFS), the order for a full tree traversal:    |
            |     --------------------------------------------------------------------------    |  
            |                                                                                   |
            |     1. root(4)->left(2)->left(1), completed in the first recursive traversal.     |
            |                                                                                   |
            |     2. backtrack to node '2' then proceed with root(4)->left(2)->right(3).        |
            |                                                                                   |
            |     3. having completed the exploration of left-side (node '2' and its children), |
            |        backtrack to root '4' then LEFT subtree of root's right-child node(6);     |
            |        Thus root(4)->right(6)->left(5).                                           |
            |                                                                                   |
            |     4. finally, complete the traversal by visiting root(4)->right(6)->right(7),   |
            |        completing the exploration of all branches more efficiently than a         |
            |        standard unbalanced BST.                                                   |   
            |                                                                                   |
            ------------------------------------------------------------------------------------|
            | each recursive traversal  |                                                       |  
            -----------------------------                                                       |  
            |   1. root(4) (indent="  ", last=true) --  prints:       '└─4'                     |  
            |   2. node(2) (indent="| ", last=false)--  prints:       '  ├─2'                   |  
            |   3. node(1) (indent="| ", last=false)--  prints:       '  | ├─1'                 |  
            |   4. node(3) (indent="  ", last=true) --  prints:       '  | └─3'                 |  
            |   5. node(6) (indent="    ", last=true) --  prints:     '  └─6'                   |  
            |   6. node(5) (indent="    ", last=false)--  prints:     '    ├─5'                 |
            |   7. node(7) (indent="      ", last=true) --  prints:   '    └─7'                 |
            |            ^^^NOT USED 6 indents^^^                                               |                    |
            |   note 5 and 7 have 4 spaces of indentation, this is because the recursion carrys |
            |   over from the previous call due to 'indent' string accumulation from past calls,|
            |   if needed, to structure hierarchy to align child nodes under their respective   |
            |   parent nodes, the indent string is += and printed start of next recursive call; |
            |   thus last time round indent is NOT printed as it it doesn't get that far in the |   
            |   recusive call because it doesn't call itself again after node(7)                |                                                  |                                                                                 
            |   the final +2->'=6' indents NEVER used;                                          |
            |   last could also be thought of as first(before) next recusive call, or NOT       |
            |   intermediate. Thus the algorithm searches for nodes in given AVL tree FASTER    |
            |   the a standard unbalanced BST, thereby improving time-complexity for searches   |                                                                                                                                             |                            
            -------------------------------------------------------------------------------------

```

## Maths for Machine Learning

{machine learning maths...}

## Applied Mathematics

This section showcases examples of applying mathematical principles in real-world scenarios. Whether it's through programming projects, statistical analysis, or model simulations, the application of theory to practice is vividly depicted.

{Elaborate...}

## Tools and Software I Use

<a href="https://uk.mathworks.com/products/matlab.html" target="_blank" style="color: #448c88"><b>`MATLAB`</b></a>`: A staple in my computational mathematics toolkit.

<a href="https://numpy.org/" target="_blank" style="color: #448c88"><b>`NumPy`</b></a>`: Essential for data manipulation and numerical computations in Python.

## My Mathematical Achievements

I highlight my recognitions and awards in mathematics, which reflect my dedication and skill in the field:

2022 - Received 83% in my foundation year mathematics module: 97.92% in the coursework, and 62.86% in the exam.

2024 - In my first-year mathematics module, in my second semester, after prolonged recovery from my injury, I achieved {…} in the module, 80.67% in the exam, and {…} in the coding report.

<!--## Recent Blog Posts

Stay updated with my latest thoughts and explorations in mathematics:

- [Math in Machine Learning](/posts/math-in-ml)
-->

<!-- FIX THIS [ ] -->

## Contact Me

I am always open to discussions about mathematical concepts or potential collaborations. Feel free to [get in touch](mailto:alfienurse@gmail.com)!
