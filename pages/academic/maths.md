---
layout: archive
author_profile: true
header:
  overlay_image: /assets/splash/header.png
title: "Mathematics"
permalink: /maths/
---

<a href="https://alfie-ns.github.io/documents/results_image_only.pdf" target="_blank" class="accent-link">As an enthusiast of mathematics</a>, I explore various captivating mathematical concepts. My studies at the University of Plymouth, where I am pursuing a BSc (Hons) in Computer Science with a focus on Artificial Intelligence, often intertwine with my mathematical interests.

Recently, I have been developing an efficient <a href="https://github.com/alfie-ns/1003-CW/blob/main/Report/AVL/Solution" target="_blank" class="accent-link">C# AVL tree</a> for my university coursework, achieving <a href="/documents/COMP1003-Report-Marks--24.xlsx" target="_blank" class="accent-link">81.6%</a>. Anyone can quickly run this project with the .NET SDK to easily observe a complex search algorithm with a bash script in the terminal.

The program generates a visual representation of the <a href="https://en.wikipedia.org/wiki/AVL_tree" target="_blank" class="accent-link">AVL tree</a> using box-drawing characters and necessary indentation, by running `./AVL-run.sh` in the terminal.

<a href="https://github.com/alfie-ns/1003-CW/tree/main/Report/AVL/Solution" target="_blank" class="accent-link">This project</a> effectively demonstrates a mathematically intricate and intriguing search algorithm, displaying a depth-first traversal, thereby showing the structure from the root node downwards through its subtrees.

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
            |             └─7  7(last)'s indent(6->7) accumulation used next call is NOT used   |
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
            -------------------------------------------------------------------------------------
```

## Maths for Machine Learning

*Coming soon...*

## Applied Mathematics

This section showcases examples of applying mathematical principles in real-world scenarios. Whether it's through programming projects, statistical analysis, or model simulations, the application of theory to practice is vividly depicted.

*Coming soon...*

## Tools and Software

<a href="https://numpy.org/" target="_blank" class="accent-link"><strong>NumPy</strong></a>: Essential for data manipulation and numerical computations in Python.

## My Mathematical Achievements

I highlight my recognitions and awards in mathematics, which reflect my dedication and skill in the field:

- **2022** - Received 83% in my foundation year mathematics module: 97.92% in the coursework, and 62.86% in the exam.
- **2024** - In my first-year mathematics module, in my second semester, after prolonged recovery from my injury, I achieved 80.67% in the exam, and 81.6% (the second-highest grade) in the coding report.
