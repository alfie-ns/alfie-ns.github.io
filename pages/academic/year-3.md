---
layout: archive
author_profile: true
header:
  overlay_image: /assets/splash/header.png
title: "Year 3"
permalink: /year-3/
---

## COMP3003: Machine Learning: 78%

COMP3003 was my machine learning module in final year, covering both theoretical foundations and practical implementation. The module had two assessed components: **Set Exercises** (Bayes classifiers and clustering) and a **Report** (reinforcement learning and classification). All implementations were built in MATLAB from first principles, and all write-ups were produced in LaTeX.

![3003-grade](/image/year-3/3003-grade.png)

---

### Set Exercises

#### Task 1: Bayes Classifiers

I calculated posterior probabilities by hand using both **Naive Bayes** and **Joint Bayes** classifiers on a Boolean training set. The Naive classifier assumes feature independence given the class label, decomposing the joint likelihood as $P(x,y,z \mid U) = P(x \mid U) \cdot P(y \mid U) \cdot P(z \mid U)$, which lets you multiply individual feature probabilities rather than counting every possible combination. The Joint classifier, by contrast, directly counts feature-pattern occurrences without any independence assumption.

I computed posteriors as evidence accumulates, starting with one feature, then two, then three, and discovered a **non-monotonic progression**: $P(U=1 \mid x=0) = 0.5$ (one feature), $P(U=1 \mid x=0, y=1) = 0.6$ (two features), $P(U=1 \mid x=0, y=1, z=1) = 0.36$ (three features). Rather than converging smoothly as more evidence is added, the posterior fluctuates because each feature provides conflicting evidence about the class label. I produced a TikZ diagram illustrating this behaviour and cited Domingos and Pazzani (1997) who mathematically demonstrated that Naive Bayes can still be optimal for classification even when independence is violated, as long as the class ranking of posteriors is preserved.

#### Task 2: K-Means and GMM Clustering

I implemented **K-Means clustering from first principles** in MATLAB, including:

- **K-Means++ initialisation** (Arthur and Vassilvitskii, 2007): selects initial centroids proportional to squared distance from existing centres, avoiding poor local minima
- **Lloyd's algorithm**: the iterative assign-update loop with convergence tracked via the Frobenius norm of centroid displacement
- **Stable multi-run**: 20 independent runs returning the lowest WCSS result
- **Elbow Method**: evaluated WCSS across $k = 1$ to $10$, confirming $k = 5$ as optimal (Silhouette score peaked at 0.899)

I generated a synthetic dataset of 4,500 points across five 2-D Gaussian clusters arranged in a pentagonal pattern, then compared my from-scratch K-Means against MATLAB's built-in **Gaussian Mixture Model** (`fitgmdist`). Both achieved near-identical metrics (Silhouette: 0.899, Davies-Bouldin: 0.358, Calinski-Harabasz: 20,119) because the spherical cluster geometry satisfies K-Means' geometric assumptions perfectly.

| Metric | K-Means | GMM |
|---|---|---|
| Silhouette Coefficient | 0.899 | 0.899 |
| Davies-Bouldin Index | 0.358 | 0.358 |
| Calinski-Harabasz Score | 20,119 | 20,116 |

---

### Report

#### Task 3: Reinforcement Learning (Q-Learning & MDPs)

I analysed a **5-state Markov Decision Process** with deterministic transitions and a single high-reward transition ($S_4 \to S_5$, reward = 10, versus reward = 1 elsewhere).

I derived the **optimal policy** for each state by applying the Bellman optimality equation, showing the agent should move Right at every state except $S_5$ (forced Left), creating an infinite $S_4 \leftrightarrow S_5$ harvesting loop. I then computed $V^*(S_5)$ symbolically in terms of the discount factor $\gamma$:

$$V^*(S_5) = \frac{1 + 10\gamma}{1 - \gamma^2}$$

For the Q-learning trace, using a **greedy policy** (always choose max Q-value, break ties Left) with $\alpha = 0.5$ and $\gamma = 0.8$, I traced the first 10 state-action pairs starting from $S_3$. The agent becomes **permanently trapped** in an $S_1 \leftrightarrow S_2$ oscillation after Step 1, because $Q(S_3, \text{Left})$ gets updated to 0.5 whilst $Q(S_3, \text{Right})$ remains at 0, so the greedy policy never explores rightward toward the high-reward transition. The Q-values bootstrap off each other with diminishing increments consistent with Tsitsiklis's (1994) contraction mapping theory.

This demonstrates the **exploration-exploitation trade-off**: purely greedy (exploitative) behaviour prevents discovery of the optimal strategy. Even modest $\varepsilon$-greedy exploration ($\varepsilon = 0.1$) would eventually sample $(S_3, \text{Right})$ and discover the optimal cycle.

#### Task 4: Neural Network vs Naive Bayes Classification

I built and compared two classifiers for **PCOS (Polycystic Ovary Syndrome) diagnosis** on a dataset of 541 patients with 41 clinical features:

**Neural Network** (41-25-12-1 pyramidal architecture):
- Feedforward network with `tansig` hidden activations and sigmoid output
- Scaled conjugate gradient backpropagation with early stopping (patience = 20)
- 1,375 trainable parameters
- Fold-wise z-score normalisation to prevent data leakage

**Gaussian Naive Bayes**:
- Gaussian likelihood with parameters estimated via maximum likelihood
- Only 164 parameters (41 means + 41 variances per class)
- Trained ~13x faster than the neural network

Both were evaluated using **stratified 10-fold cross-validation**, experimentally selected over $k = 5$ and $k = 15$ using a stability-adjusted performance criterion.

| Metric | Neural Network | Naive Bayes | Winner |
|---|---|---|---|
| Accuracy | 87.8% ± 5.7% | 84.5% ± 3.8% | NN |
| Precision | 84.1% ± 10.7% | 73.5% ± 7.1% | NN |
| Recall | 78.7% ± 11.0% | 84.8% ± 11.1% | NB |
| F1-Score | 80.9% ± 8.9% | 78.1% ± 5.1% | NN |
| AUC | 0.945 ± 0.032 | 0.901 ± 0.054 | NN |
| Brier Score | 0.088 | 0.136 | NN |

The neural network achieved superior discrimination (AUC 0.945), but Naive Bayes demonstrated **higher recall** (84.8% vs 78.7%), meaning it catches more true PCOS cases at the expense of more false positives. This means classifier choice depends on the application's cost function: neural networks maximise discrimination, whereas Naive Bayes maximises recall, suiting contexts where missing a diagnosis is penalised more heavily.

---

### Tools & Skills Used

<div class="project-card">
<div class="tech-tags">
  <span class="tech-tag">MATLAB</span>
  <span class="tech-tag">LaTeX</span>
  <span class="tech-tag">K-Means</span>
  <span class="tech-tag">GMM</span>
  <span class="tech-tag">Neural Networks</span>
  <span class="tech-tag">Naive Bayes</span>
  <span class="tech-tag">Q-Learning</span>
  <span class="tech-tag">Reinforcement Learning</span>
  <span class="tech-tag">Cross-Validation</span>
</div>
</div>
