# Risk Assessment Evaluation Rubric

Use this rubric to score outputs from `assess-risk`.

## Scoring (0-2 per dimension, 10 total)

### 1. Risk Identification Completeness (0-2)

| Score | Criteria |
|-------|----------|
| 2 | All material risks from the input data are identified. Risk categories are appropriate. No obvious risk is missed. |
| 1 | Most risks identified but one material risk is missing |
| 0 | Multiple obvious risks missed, or risks are fabricated without evidence |

### 2. Scoring Accuracy (0-2)

| Score | Criteria |
|-------|----------|
| 2 | Likelihood and impact scores are well-calibrated. A "5 likelihood" risk is genuinely almost certain. Severity = L x I is computed correctly. |
| 1 | Scores are reasonable but calibration is loose (e.g., everything scored 3-4 with no differentiation) |
| 0 | Scores are random, not justified, or mathematically wrong |

### 3. RAG Consistency (0-2)

| Score | Criteria |
|-------|----------|
| 2 | RAG status per risk matches severity score ranges. Overall RAG reflects the worst individual RAG appropriately. |
| 1 | Individual RAGs are correct but overall RAG is debatable |
| 0 | RAG contradicts severity scores |

### 4. Mitigation Quality (0-2)

| Score | Criteria |
|-------|----------|
| 2 | Top 3 recommendations are specific (what, who, by when), actionable, and proportional to the risk severity |
| 1 | Recommendations exist but are generic or missing owners/deadlines |
| 0 | No recommendations, or recommendations are "monitor the situation" |

### 5. Evidence and Grounding (0-2)

| Score | Criteria |
|-------|----------|
| 2 | Every risk traces to specific input data (ticket keys, dependency names, capacity figures). No unsupported claims. |
| 1 | Most risks are grounded but 1-2 lack specific evidence |
| 0 | Risks are generic and not tied to the provided data |

## Verdict

| Total | Verdict |
|-------|---------|
| 8-10 | **Pass** |
| 5-7 | **Iterate** |
| 0-4 | **Fail** |
