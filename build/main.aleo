program humine_health_records_test1.aleo;

struct StudyDetails:
    study_title as u64;
    study_id_int as u64;
    organization as address;
    created_date as u64;
    started_date as u64;

record Study:
    owner as address.private;
    id as field.private;
    id_int as u64.private;
    details as StudyDetails.private;

struct EventDetails:
    created_date as u64;
    completed_date as u64;
    completed_by as address;
    study_id_int as u64;
    event_type as u64;
    source_type as u64;
    source_device_id_int as u64;

record Event:
    owner as address.private;
    id as field.private;
    id_int as u64.private;
    details as EventDetails.private;

struct TaskDetails:
    created_date as u64;
    completed_date as u64;
    completed_by as address;
    study_id_int as u64;
    task_type as u64;
    source_type as u64;
    source_device_id_int as u64;

record Task:
    owner as address.private;
    id as field.private;
    id_int as u64.private;
    details as TaskDetails.private;

struct PublicTask:
    created_date as u64;
    completed_date as u64;
    study_id_int as u64;
    task_type as u64;


mapping all_events:
	key left as field.public;
	value right as u64.public;


mapping adverse_events:
	key left as field.public;
	value right as u64.public;


mapping expected_events:
	key left as field.public;
	value right as u64.public;


mapping task_completions:
	key left as field.public;
	value right as u64.public;

function create_study:
    input r0 as StudyDetails.private;
    assert.eq self.caller r0.organization;
    hash.bhp256 r0.study_title into r1 as field;    hash.bhp256 r1 into r2 as u64;    cast self.caller r1 r2 r0 into r3 as Study.record;
    output r3 as Study.record;

    finalize r1;

finalize create_study:
    input r0 as field.public;
    set 0u64 into all_events[r0];
    set 0u64 into adverse_events[r0];
    set 0u64 into expected_events[r0];


function new_adverse_event:
    input r0 as u64.private;
    input r1 as EventDetails.private;
    assert.eq self.caller r1.completed_by;
    hash.bhp256 r1.completed_by into r2 as u64;    add r1.study_id_int r2 into r3;
    add r3 r1.event_type into r4;
    add r4 r1.completed_date into r5;
    hash.bhp256 r5 into r6 as field;    hash.bhp256 r6 into r7 as u64;    cast self.caller r6 r7 r1 into r8 as Event.record;
    output r8 as Event.record;

    finalize r1.study_id_int;

finalize new_adverse_event:
    input r0 as u64.public;
    hash.bhp256 r0 into r1 as field;    get.or_use adverse_events[r1] 0u64 into r2;
    add r2 1u64 into r3;
    set r3 into adverse_events[r1];
    get.or_use all_events[r1] 0u64 into r4;
    add r4 1u64 into r5;
    set r5 into all_events[r1];


function new_expected_event:
    input r0 as u64.private;
    input r1 as EventDetails.private;
    assert.eq self.caller r1.completed_by;
    hash.bhp256 r1.completed_by into r2 as u64;    add r1.study_id_int r2 into r3;
    add r3 r1.event_type into r4;
    add r4 r1.completed_date into r5;
    hash.bhp256 r5 into r6 as field;    hash.bhp256 r6 into r7 as u64;    cast self.caller r6 r7 r1 into r8 as Event.record;
    output r8 as Event.record;

    finalize r1.study_id_int;

finalize new_expected_event:
    input r0 as u64.public;
    hash.bhp256 r0 into r1 as field;    get.or_use expected_events[r1] 0u64 into r2;
    add r2 1u64 into r3;
    set r3 into expected_events[r1];
    get.or_use all_events[r1] 0u64 into r4;
    add r4 1u64 into r5;
    set r5 into all_events[r1];


function new_task_completion:
    input r0 as u64.private;
    input r1 as TaskDetails.private;
    assert.eq self.caller r1.completed_by;
    hash.bhp256 r1.completed_by into r2 as u64;    add r1.study_id_int r2 into r3;
    add r3 r1.task_type into r4;
    add r4 r1.completed_date into r5;
    hash.bhp256 r5 into r6 as field;    hash.bhp256 r6 into r7 as u64;    cast self.caller r6 r7 r1 into r8 as Task.record;
    cast r1.created_date r1.completed_date r1.study_id_int r1.task_type into r9 as PublicTask;
    output r8 as Task.record;

    finalize r1.study_id_int r9;

finalize new_task_completion:
    input r0 as u64.public;
    input r1 as PublicTask.public;
    hash.bhp256 r0 into r2 as field;    get.or_use task_completions[r2] 0u64 into r3;
    add r3 1u64 into r4;
    set r4 into task_completions[r2];
