# Computational Techniques in Biomedicine — Lab Portfolio

Practical assignments from the **Técnicas Computacionales en Biomedicina** course, Biomedical Engineering degree, Universidad de Valladolid (2024–2025).

The course is structured in two blocks: **Block I** covers the full machine learning pipeline applied to clinical data (MATLAB), and **Block II** covers deep neural networks (Python · Keras/TensorFlow).

---

## Block I — Clinical Data Analysis and Predictive Modelling (MATLAB)

All practices in this block work with real clinical datasets from respiratory disease patients (obstructive sleep apnoea and COPD), following a complete supervised learning pipeline from raw data to validated predictive model.

---

### P1 · Data Curation
**Techniques:** Missing value detection and imputation, outlier detection, exploratory data analysis.

- Identification and indexing of missing values in a real electronic health record dataset (respiratory pathology context).
- Implementation of four imputation strategies: global mean, class mean, trimmed mean (20% trim), and k-nearest neighbours (k = 5).
- Univariate outlier detection via boxplots and z-score thresholding.
- Multivariate outlier detection using robust Mahalanobis distance estimation (`robustcov`, outlier fraction = 0.05).
- 2D scatter visualisation of outlier distribution across variable pairs.

**Data:** Real clinical database with demographic, anthropometric and biomedical signal features from adult OSA patients.

---

### P2 · Predictive Modelling and Performance Metrics
**Techniques:** Binary logistic regression, confusion matrix metrics, ROC analysis, Youden index.

- Binary logistic regression (LR) classifier design using `glmfit`/`glmval`, applied to imputed clinical data (OSA diagnosis).
- Multicollinearity detection via correlation matrix; removal of redundant variables (r > 0.8).
- Probability output visualisation for different classification thresholds (25%, 50%, 75%).
- Implementation from scratch of all confusion matrix metrics: sensitivity (Se), specificity (Sp), PPV, NPV, LR+, LR−, accuracy (Acc).
- Youden index optimisation for threshold selection; comparison across threshold strategies.

---

### P3 · Bootstrap Validation
**Techniques:** Bootstrap 0.632, confidence interval estimation, robust performance assessment.

- Full implementation of the bootstrap 0.632 method for unbiased estimation of classifier performance metrics (Se, Sp, PPV, NPV, LR+, LR−, Acc).
- Per-iteration train/test split with standardisation using training set statistics applied to test data.
- Bootstrap confidence intervals (95%) via percentile method across B iterations.
- Histogram visualisation of bootstrap distribution for accuracy with CI bounds.

---

### P4 · Genetic Algorithm Feature Selection
**Techniques:** Genetic algorithms, feature selection, hold-out validation, COPD readmission prediction.

- Design and implementation of a genetic algorithm (GA) using MATLAB's `ga` solver (Global Optimization Toolbox) for optimal feature subset selection.
- Custom fitness function: binary LR model trained on 60% stratified split, evaluated on 40% test set; accuracy as optimisation objective.
- Configuration of GA parameters: population size, crossover strategy and probability, mutation strategy and probability, elitism, maximum generations.
- Stratified initial population design to ensure full search space coverage.
- Custom plotting functions for best individual fitness and population average across generations.

**Data:** Real COPD patient database with sociodemographic, anthropometric, comorbidity, quality-of-life and clinical admission variables; target: 30-day hospital readmission.

---

### Exam · Block I Integrated Assessment
End-of-block practical exam integrating the full pipeline: data curation → logistic regression → bootstrap validation → genetic algorithm feature selection on clinical data.

---

## Block II — Deep Neural Networks (Python · Keras / TensorFlow)

---

### L00 · Introduction to DNNs
- First DNN implementation in Keras (`Sequential` API): architecture definition, compilation, training and evaluation.
- Understanding of `model.fit()`, `model.predict()`, `model.summary()` and `model.compile()`.

### L01 · DNN Classification
- Binary and multiclass classification with dense layers.
- Activation functions: sigmoid, softmax, ReLU; loss functions: binary crossentropy, sparse categorical crossentropy.
- Train/validation split, learning curves (loss and accuracy vs. epochs).

### L02 · DNN Training Strategies
- Overfitting detection via train/validation generalisation gap analysis.
- Regularisation strategies: dropout, early stopping.
- Optimiser comparison and learning rate tuning.

### L03 · Binary Classification with DNNs
- Full binary classification pipeline on clinical tabular data.
- Threshold selection, confusion matrix computation, performance metric analysis.
- Model comparison across architectures.

### L04 · CNN Multiclass Image Classification
- Introduction to Convolutional Neural Networks (CNNs) for medical image classification.
- Conv2D, MaxPooling, Flatten layers; multiclass output with softmax.
- Training on labelled image dataset; accuracy and loss monitoring.

---

## Skills demonstrated

| Area | Tools / Methods |
|---|---|
| Data preprocessing | Missing value imputation (mean, trimmed mean, kNN), outlier detection (Mahalanobis) |
| Predictive modelling | Logistic regression, confusion matrix metrics, ROC, Youden index |
| Model validation | Bootstrap 0.632, confidence intervals, hold-out, stratified splitting |
| Optimisation | Genetic algorithms, feature selection, custom fitness functions |
| Deep learning | DNNs, CNNs, Keras/TensorFlow, binary and multiclass classification |
| Languages | MATLAB, Python |
| Data | Real clinical databases: OSA patients (EHR + biomedical signal features), COPD readmission, medical images |

---

## Context

These labs are part of the 3th-year Biomedical Engineering curriculum at Universidad de Valladolid. The bootstrap validation and logistic regression techniques developed here are directly applied in my Final Year Project on hospital occupancy prediction (Hospital Universitario Río Hortega, SACYL), where bootstrap confidence intervals are used to characterise model uncertainty. The deep learning block complements Erasmus coursework in Machine Learning at Politecnico di Milano.
