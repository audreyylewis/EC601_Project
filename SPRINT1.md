1. Mission.  One sentence, using the template from class. Do not call it final — it is your best guess until your first test says otherwise.
For hardware engineers who need to build tiny, battery-less medical sensors, the Intermittent Computing Prototype is a custom software simulation that guarantees a device can finish its work on weak, flickering power. Unlike traditional computer chips that wipe their memory and reboot every time the voltage drops, it saves the sensor's exact progress to permanent memory and resumes when energy returns.

2. Target user.  One specific person. If your product has several users, name the primary one and build for them first.
Hardware Systems Architect for in vivo biological edge devices.

3. User stories.  Your top 5, with acceptance criteria. Put them on your GitHub board as issues — the board is the plan; the document just explains it.
Story 1: The Hardware Interrupt
As an RTL designer, I want a dedicated "Survival Controller" FSM that listens for a low-voltage interrupt, so that the chip can instantly halt the main processor.
Acceptance Criteria:
Interrupt pin going HIGH transitions the FSM from ACTIVE to HALT state.
Clock gating successfully pauses the main datapath within 2 clock cycles.
Story 2: The Emergency Save
As a systems engineer, I want the FPGA to automatically serialize and blast all in-progress data to the FRAM, so that the chip doesn't lose its intermediate math.
Acceptance Criteria:
FSM transitions to FLUSH_NVM.
SPI controller successfully writes the entire 32-bit state register block to the external FRAM.
Write completes before the system voltage drops below the operational threshold.
Story 3: The Resumption Boot Sequence
As an RTL designer, I want the chip's boot-up sequence to default to checking the FRAM first, so that the system restores its saved progress rather than starting from zero.
Acceptance Criteria:
Power-On Reset (POR) defaults to a RESTORE state, not an IDLE/RESET state.
SPI controller reads the previous state from FRAM and populates the active registers before enabling the main datapath clock.
Story 4: The Harvester Simulation
As a hardware engineer, I want to build a specialized low-voltage RC circuit, so that I can accurately simulate the trickle-charge and rapid depletion of a micro-harvester.
Acceptance Criteria:
Circuit charges the main capacitor at < 3V.
A manual toggle switch successfully cuts input power, simulating a "passing shadow" over a solar cell or a temperature drop.
Story 5: The Pull-the-Plug Torture Test
As a test engineer, I want to introduce artificial power cuts to the FPGA while it is running a simulated workload, so that I can physically prove the device successfully saves, dies, and resumes.
Acceptance Criteria:
FPGA runs a continuous counter/math operation.
Power is manually cut and restored 25 times at random intervals.
The final mathematical output perfectly matches a software-simulated baseline, proving zero data loss across 25 power deaths.


4. Feasibility — show me, don’t tell me.  “We will use dataset X” is a wish. Downloaded, loaded by a script, committed to the repo — that is feasibility. Same for API keys and hardware: prove access this week.


5. Tooling.  Languages, frameworks, models, and why — one line each. Full setup: next slide.


6. The demo sentence.  “At the end of two weeks we will show ____ working end to end.” One sentence. If you cannot write it, your goals are too vague.






Faculty:
Rabia Tugce Yazicigil
- Tracks the developments of cyber-secure biological systems
- Question:

