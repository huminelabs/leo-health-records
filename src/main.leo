// The 'humine_health_records_test1_1lp780' program.
program humine_health_records_test1.aleo {

    // Record for studies on the Humine platform, including all relevant data types. This record is used to accurately segment tasks, events, and other records to the correct study
    record Study {
        owner: address,
        id: field,
        id_int: u64,
        details: StudyDetails
    }

    struct StudyDetails {
        study_title: u64, // Title of the study converted to an integer using .ts helper function in /ts-helpers/playground.ts
        study_id_int: u64, // Unique ID from Humine platform
        organization: address, // Sponsor/study team's wallet
        created_date: u64, // date when study was created
        started_date: u64, // date when study started to enroll participants
    }

    record Event {
        owner: address, // participant/clinician wallet address
        id: field,
        id_int: u64,
        details: EventDetails
    }

    struct EventDetails {
        created_date: u64, // when event was created
        completed_date: u64, // when event was successfully completed
        completed_by: address, // address whom reported this event -- almost always who initiates this event
        study_id_int: u64, // study ID represented as an Integer
        event_type: u64, // event type, 9 is reserved for adverse events
        source_type: u64, // // Source of the event -- this might be iPhone, Apple Watch, clinical site computer, etc
        source_device_id_int: u64 // Unique Device ID which is generated on-device at the source of data creation
    }

    record Task {
        owner: address,
        id: field,
        id_int: u64,
        details: TaskDetails
    }

    struct TaskDetails {
        created_date: u64,
        completed_date: u64,
        completed_by: address,
        study_id_int: u64,
        task_type: u64,
        source_type: u64,
        source_device_id_int: u64
    }

    // Public representation of Task, this omits identifiable information, enabling live monitoring while protecting participant privacy. This will be implemented fully when arrays are added as native types
    struct PublicTask {
        created_date: u64,
        completed_date: u64,
        study_id_int: u64,
        task_type: u64,
    }

    // Public records of events taking place -- most only counting events in addition to privacy-preserving live task completion monitoring
    mapping all_events: field => u64;
    mapping adverse_events: field => u64;
    mapping expected_events: field => u64;
    // Will be converted to field => [PublicTask] in a future Leo version.
    mapping task_completions: field => u64;

    // Add study to maps
    transition create_study(details: StudyDetails) -> Study {
        assert_eq(self.caller, details.organization);

        let study_id: field = BHP256::hash_to_field(details.study_title);
        let study_id_int: u64 = BHP256::hash_to_u64(study_id);

        return Study {
            owner: self.caller,
            id: study_id,
            id_int: study_id_int,
            details
        } then finalize(study_id);
    }

    finalize create_study(study_id: field) {
        Mapping::set(all_events, study_id, 0u64);
        Mapping::set(adverse_events, study_id, 0u64);
        Mapping::set(expected_events, study_id, 0u64);
    }

    // Report a new adverse event which can be verified without exposing participant info. This can alert sponsors of an adverse event taking place instantly without revealing any data. Site personnel and study team members that interact with participants directly can then report additional information when appropriate and allowed.
    transition new_adverse_event(study_id_int: u64, details: EventDetails) -> Event {
        assert_eq(self.caller, details.completed_by);

        let completed_by_int: u64 = BHP256::hash_to_u64(details.completed_by);
        let event_id: field = BHP256::hash_to_field(details.study_id_int + completed_by_int + details.event_type + details.completed_date);
        let event_id_int: u64 = BHP256::hash_to_u64(event_id);

        return Event {
            owner: self.caller,
            id: event_id,
            id_int: event_id_int,
            details
        } then finalize(details.study_id_int);
    }

    finalize new_adverse_event(study_id_int: u64) {
        let study_id: field = BHP256::hash_to_field(study_id_int);

        let current_adverse: u64 = Mapping::get_or_use(adverse_events, study_id, 0u64);
        Mapping::set(adverse_events, study_id, current_adverse + 1u64);

        let current_all: u64 = Mapping::get_or_use(all_events, study_id, 0u64);
        Mapping::set(all_events, study_id, current_all + 1u64);
    }

    // Report a new expected event which can be verified without exposing participant info
    transition new_expected_event(study_id: u64, details: EventDetails) -> Event {
        assert_eq(self.caller, details.completed_by);

        let completed_by_int: u64 = BHP256::hash_to_u64(details.completed_by);
        let event_id: field = BHP256::hash_to_field(details.study_id_int + completed_by_int + details.event_type + details.completed_date);
        let event_id_int: u64 = BHP256::hash_to_u64(event_id);

        return Event {
            owner: self.caller,
            id: event_id,
            id_int: event_id_int,
            details
        } then finalize(details.study_id_int);
    }

    finalize new_expected_event(study_id_int: u64) {
        let study_id: field = BHP256::hash_to_field(study_id_int);

        let current_expected: u64 = Mapping::get_or_use(expected_events, study_id, 0u64);
        Mapping::set(expected_events, study_id, current_expected + 1u64);

        let current_all: u64 = Mapping::get_or_use(all_events, study_id, 0u64);
        Mapping::set(all_events, study_id, current_all + 1u64);
    }

    transition new_task_completion(study_id: u64, details: TaskDetails) -> Task {
        assert_eq(self.caller, details.completed_by);

        let completed_by_int: u64 = BHP256::hash_to_u64(details.completed_by);
        let task_id: field = BHP256::hash_to_field(details.study_id_int + completed_by_int + details.task_type + details.completed_date);
        let task_id_int: u64 = BHP256::hash_to_u64(task_id);

        return Task {
            owner: self.caller,
            id: task_id,
            id_int: task_id_int,
            details
        } then finalize(details.study_id_int, PublicTask {
            created_date: details.created_date,
            completed_date: details.completed_date,
            study_id_int: details.study_id_int,
            task_type: details.task_type
        });
    }

    finalize new_task_completion(study_id_int: u64, public_details: PublicTask) {
        let study_id: field = BHP256::hash_to_field(study_id_int);

        let current_tasks: u64 = Mapping::get_or_use(task_completions, study_id, 0u64);
        Mapping::set(task_completions, study_id, current_tasks + 1u64);
    }
}
