# Breadboard Wiring Guide: Testing the Hardware Interrupt

This guide details how to wire the analog testbench required to validate our riskiest assumption: **Does the capacitor hold enough energy to keep the chip alive until the FSM finishes writing to permanent memory?**

## Components Needed
*   FPGA Development Board
*   Breadboard & Jumper wires
*   Manual Toggle Switch
*   Electrolytic Capacitor (100µF to 1000µF)
*   Resistors: 1x 220Ω (or 330Ω), 1x 10kΩ
*   Potentiometer (10kΩ)
*   Analog Comparator IC (e.g., LM393)
*   Oscilloscope

---

## Step 1: The Main Power Bus and Common Ground
Establish a stable power supply for the comparator and a shared ground for the logic levels.
1. Connect a `3.3V` pin from the FPGA board to the RED power rail of the breadboard.
2. Connect a `GND` pin from the FPGA board to the BLUE ground rail of the breadboard. 
*(Critical: Without this shared ground, the interrupt logic will float and fail).*

## Step 2: The Harvested Energy Circuit
Simulate the trickle-charge and rapid depletion of a micro-harvester.
1. Place the toggle switch on the breadboard. Connect one side to the `3.3V` rail.
2. Connect the other side of the switch to a new, empty row. This will be the **Declining Voltage Rail**.
3. Place the capacitor bridging the **Declining Voltage Rail** and `GND`.
4. Place the 220Ω resistor in parallel with the capacitor (bridging the **Declining Voltage Rail** and `GND`). This acts as a dummy load, simulating the power draw of the FPGA datapath.

## Step 3: The Interrupt Threshold (Reference)
Create a fixed reference voltage to dictate exactly when the hardware alarm sounds.
1. Place the potentiometer on the breadboard.
2. Connect its outer pins to the `3.3V` rail and `GND`.
3. Use a multimeter to measure the middle (wiper) pin. Adjust the dial until it outputs exactly **2.8V** (or whatever threshold gives the FSM enough time before the FPGA crashes).

## Step 4: The Comparator
Wire the comparator to trigger a `HIGH` signal when the harvested energy drops below the threshold.
1. Power the LM393 IC by connecting its `VCC` pin to the `3.3V` rail and its `GND` pin to the `GND` rail.
2. Wire the **Declining Voltage Rail** to the comparator’s **Inverting Input (IN-)**.
3. Wire the **2.8V Reference Pin** (middle potentiometer pin) to the comparator’s **Non-Inverting Input (IN+)**.

## Step 5: The FPGA Connection
Route the hardware interrupt safely to the FPGA.
1. The LM393 is an open-collector output, so place a **10kΩ pull-up resistor** connecting the `3.3V` rail to the comparator's `Output` pin.
2. Run a jumper wire from the comparator's `Output` pin directly to the assigned GPIO interrupt pin on the FPGA.

---

## The Execution & Measurement Test
To prove the riskiest assumption, run this physical test before writing the complex SPI logic:
1. Turn the toggle switch **ON**. The Declining Voltage Rail should charge up to 3.3V. The comparator output should rest at `LOW` (0V).
2. Hook **Oscilloscope Probe 1** to the Declining Voltage Rail and **Oscilloscope Probe 2** to the Comparator Output.
3. Flip the switch **OFF**.
4. **Measure $\Delta t$:** Look at the oscilloscope trace. Measure the exact time window between Probe 2 snapping `HIGH` (the interrupt) and Probe 1 dropping below the FPGA's minimum operating voltage (e.g., 2.0V). 

**Kill Criterion:** If $\Delta t$ is shorter than the time required to clock 32 bits over SPI at the target frequency, the architecture fails. You must increase the capacitor size before touching SystemVerilog.