# Humine Aleo Deploy Incentives Submission
## Overview
Humine is a privacy-centric clinical trial platform that empowers participants with cash compensation for the data they contribute in trials. As a core part of the technical architecture, Humine uses Zero-Knowledge proofs on the Aleo blockchain and on-device processing on iPhone to create a completely trustless audit trail, making live auditing by multiple parties possible during the trial while maintaining blinding and ensuring participant privacy.

This project outlines the initial set of Leo programs deployed on Aleo by Humine which makes this all possible. As Humine uses on-device processing on iPhone, rather than a web-based wallet, certain elements are still under development, preventing a full-scale demo. Nonetheless, a demo featuring this Leo program and user flow on the Humine iOS app is available [here](https://youtu.be/TFS-YPsEwIw).

This project is documented throughout, pointing out how Leo language features are used to create studies on the chain and reporting task completions and both expected and adverse events during a trial.

## Build Guide
To execute this Leo program, run:

```bash
leo run create_study
leo run new_task_completion
leo run new_expected_event
leo run new_adverse_event
```

## Functionality
The Humine Health Records leo program verifiably tracks both expected and adverse events as well as study task completions in a privacy preserving manner. These logged instances are associated with specific studies on the Humine platform which is also tracked in a privacy preserving manner in the Leo program.

### Study
Each study on the Humine platform is accounted for by `Study` records in the Leo program. These records are created using the `create_study` transition. This creates a unique study ID, currently using the study's title but will be transitioned to use Humine's own unique ID system. The ID is represented as a `field` and an unsigned integer, `u64` for interoperability with Humine's systems.

Studies created using the transition are also added to the `all_events`, `adverse_events`, `expected_events`, and `task_completion` mappings to keep track of its respective events and tasks using a `finalize` function. This keeps count of events and tasks publicly, while keeping identifiable data private, to give regulators, sponsors, and other study personnel visibility and assurance of studies live while maintaining the privacy of participants and the integrity of the data being gathered,

### Events
Events are logged using the `new_expected_event` and `new_adverse_event` transitions for expected and adverse events, respectively. Expected events are those that are part of the study protocol and logs expected outcomes during the course of a clinical trial. Adverse events are unexpected negative effects that a participant has seen during the trial, that may or may not be caused by the intervention being tested.

This is vital to log in a privacy-preserving manner as adverse events are currently managed by study personnel that are in direct contact with participants with information propogating up the chain as necessary which can have significant lag time. Aleo's privacy preserving blockchain gives visibility to study teams instantly, enabling them to proactively address these critical moments in a trial.

Each event uses its respective `transition` and `finalize` functions to create records and publicly count events being logged. ZK proofs are created where and almost immediately after the event takes place. As an example, a clinic visit verifying an adverse reaction to a medication leads to the clinician entering the participant's history in the clinic's EHR system. It is at this point a Zero Knowledge proof is created, taking input the `source_type`, in this case being clinic EHR, `source_device_id_int` being a unique UUID created on the specific computer which accessed the clinic's EHR in addition to the EHR record itself. This produces an `Event` record.

### Tasks
Tasks are expected actions taken by participants during the course of a clinical trial, as per the study protocol. This inludes surveys, wearable samples like ECGs on an Apple Watch or wearing it to sleep producing passive data, going to a clinic for a study checkup, or completing an educational module.

These tasks are logged using the `new_task_completion(study_id:details:)` `transition` and `finalize` functions. Tasks verify the place and time where it was completed, ensuring that data being generated is scientifically sound and unbiased for use in data analysis. Fields in the `Task` record including `source_type` and `source_device_id_int` ensure data integrity by verifying that tasks are completed by the right participant on the right device within the time window expected by the study team. This saves significant time and resources during data analysis later on in the study's timeline as less cleanup is needed.

Tasks are also logged publicly using a separate struct `PublicTask`. As arrays are not yet supported in Leo, the actual mapping for this is not yet in the program. The `task_completions` mapping will be adjusted when this feature is adopted in the language.

## Implementation
These Leo programs are implemented on the Humine iOS app -- where programs are executed ideally on-device achieving maximum privacy -- and the Humine study portal. The iOS app uses the Swift SPM package from Humine's fork of the Aleo SDK which enables on-device creation of Aleo accounts and Leo program execution. The study portal uses the WASM package from the Aleo SDK. Implementations of this Leo program are designed to run invisible to the user, making a privacy-preserving audit trail completely transparent in the user experience. The user's use of Passkeys, FaceID, and other security features makes on-device ID, password, and account generation possible.

## Future Work
Humine continues to iterate on this and other Leo programs which will serve as the foundational layer to the Humine participant app, Humine study portal, as well as partner platforms covering many other parts of the clinical trial workflow.