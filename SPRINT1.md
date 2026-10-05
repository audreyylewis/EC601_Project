1. Mission.
For hardware engineers who need to build tiny, battery-less medical sensors, the Intermittent Computing Prototype is a custom software simulation that guarantees a device can finish its work on weak, flickering power. Unlike traditional computer chips that wipe their memory and reboot every time the voltage drops, it saves the sensor's exact progress to permanent memory and resumes when energy returns.

2. Target user.
Hardware Systems Architect for in vivo biological edge devices.

3. User stories. 
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


5. Tooling.
* **Language:** SystemVerilog – Required to design the custom synthesizable hardware state machine (the Survival Controller) at the register-transfer level.
* **Framework:** Xilinx Vivado – Necessary to synthesize the SystemVerilog code, simulate the clock cycles, and flash the logic onto the physical FPGA board.
* **Model or API:** OpenAI `gpt-4o-mini` – The the survival mechanism relies entirely on bare-metal hardware logic, as software-based APIs consume too much power and time during a brownout. This model will be used for help with research throughout the process. Inexpensive ($0.15/1M input, $0.60/1M output tokens; default tier 1 rate limit 500 RPM / 200k TPM) for fast structured outputs.
* **Data Tools:** Python (NumPy/Matplotlib) – Needed to compute the baseline continuous math simulation to verify against the FPGA's final data output after 25 power deaths.
* **Testing Tool:** Oscilloscope and Logic Analyzer – Required to physically measure the analog voltage discharge curve and verify the exact SPI transmission timing before the power rail completely collapses.
* **Where it runs:** Local laptop and physical lab bench – The final test requires manually unplugging the power to simulate hardware death, which cannot be done remotely on the SCC or via cloud credits.

6. The demo sentence.  “At the end of two weeks we will show a complete plan and documentation set that outlines the entirety of the next few weeks.” 

Riskiest assumption/its cost:
 - Assumption: we can consistently detect a collapsing voltage rail and trigger a hardware interrupt fast enough to give the FPGA time to act before the voltage drops below the SRAM physical retention limit.
 - Cost: Least costly approach is to build a reliable hardware base first and then move on to software, rather than building software to fix buggy hardware.
 - "We pivot if...": the oscilloscope measurement shows the voltage collapses from the interrupt threshold to the SRAM failure threshold in less time than it takes to transmit 32 bits of state data over SPI at our maximum reliable clock frequency.
 Other assumptions:
 - We can complete a full SPI serialization and write transaction to the external FRAM within the tiny microsecond energy window provided by the dying capacitor.
 - We can accurately simulate a stochastic, weak ambient energy harvester (a fluctuating current source) on a breadboard to predictably test the FPGA's response.

Potential harm:
 - The worst realistic misuse is an adversary intentionally manipulating the ambient energy field to trigger constant emergency saves, weaponizing the device's own survival mechanism to perform a denial-of-service attack on a medical implant.
 - Additionally, a corrupted write to the permanent memory could permanently brick the device *in vivo*, requiring the patient to undergo an invasive emergency surgery to extract it.
 - If the survival circuit misses its nanosecond deadline, patients relying on these bio-sensors will suffer misdiagnoses from corrupted or completely lost physiological data.


Faculty:
Rabia Tugce Yazicigil
- Tracks the developments of cyber-secure biological systems
- Directs the WISE-Circuits Lab at BU
- Co-authored foundational papers on both sub-1.4 cm³ ingestible capsules (2023) and        hardware-accelerated security for medical implants (Maji et al., 2020).
- Question: When designing cyber-secure biological systems that run on intermittent energy, do you consider the biggest security vulnerability to be the energy cost of re-authenticating the device every single time it wakes up from a power loss, or the physical vulnerability of the data while it sits unpowered in permanent memory?

Ajay Joshi 
- Leads the Integrated Circuits and Systems Group at BU
- Specializes in hardware security, VLSI, and low-power architectures
- Question: When securing a device that runs on harvested energy, how do you balance the energy budget between doing the actual computational work and defending against 'denial-of-sleep' attacks?

