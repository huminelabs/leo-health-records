# Humine Aleo Deploy Incentives Submission
## Overview
Humine is a privacy-centric clinical trial platform that empowers participants with cash compensation for the data they contribute in trials. As a core part of the technical architecture, Humine uses Zero-Knowledge proofs on the Aleo blockchain and on-device processing on iPhone to create a completely trustless audit trail, making live auditing by multiple parties possible during the trial while maintaining blinding and ensuring participant privacy.

This project outlines the initial set of Leo programs deployed on Aleo by Humine which makes this all possible. As Humine uses on-device processing on iPhone, rather than a web-based wallet, certain elements are still under development, preventing a full-scale demo. Nonetheless, a demo featuring this Leo program and user flow on the Humine iOS app is available [here](https://youtu.be/TFS-YPsEwIw).

This project is documented throughout, pointing out how Leo language features are used to create studies on the chain and reporting task completions and both expected and adverse events during a trial.

## Build Guide
To execute this Aleo program, run:
```bash
leo run create_study
leo run new_task_completion
leo run new_expected_event
leo run new_adverse_event
```
