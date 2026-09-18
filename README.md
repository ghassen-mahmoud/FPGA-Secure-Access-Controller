# 🔐 FPGA Secure Access Controller

A VHDL-based password access controller implemented on a **Terasic DE10-Standard FPGA** using **Intel Quartus Prime 18.1**.

The project implements a finite state machine (FSM) to verify a 10-bit password, manage incorrect attempts, and lock the system after three failed attempts.

---

## 📌 Project Overview

The system simulates a simple digital access-control mechanism.

The user enters a 10-bit password using the FPGA switches and presses the **ENTER** button to start the verification.

* ✅ Correct password → Access granted
* ❌ Incorrect password → Wrong attempt
* 🔒 Three incorrect attempts → System locked
* 🔓 UNLOCK button → Reset the attempt counter and return to the idle state

The design is implemented entirely in **VHDL** and tested on real FPGA hardware.

---

## 🧩 System Architecture

The controller is implemented using a finite state machine:

```text
                    ┌──────────────┐
                    │     IDLE     │
                    │   Waiting    │
                    └──────┬───────┘
                           │
                       ENTER
                           │
                           ▼
                    ┌──────────────┐
                    │    CHECK     │
                    │  Compare PW  │
                    └──────┬───────┘
                           │
                  ┌────────┴────────┐
                  │                 │
              Incorrect          Correct
                  │                 │
                  ▼                 ▼
            ┌──────────┐      ┌──────────┐
            │  WRONG   │      │ GRANTED  │
            └────┬─────┘      └────┬─────┘
                 │                 │
                 │                 │
                 ▼                 ▼
            ┌──────────┐      ┌──────────┐
            │ RELEASE  │      │ RELEASE  │
            └────┬─────┘      └────┬─────┘
                 │                 │
                 └────────┬────────┘
                          │
                          ▼
                        IDLE

              After 3 incorrect attempts
                          │
                          ▼
                    ┌──────────┐
                    │  LOCKED  │
                    └────┬─────┘
                         │
                       UNLOCK
                         │
                         ▼
                       IDLE
```

---

## 🔄 FSM States

| State     | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `IDLE`    | Waits for the ENTER button                                         |
| `CHECK`   | Compares the entered password with the stored password             |
| `WRONG`   | Indicates an incorrect password and increments the attempt counter |
| `GRANTED` | Indicates that the password is correct                             |
| `RELEASE` | Waits for the ENTER button to be released                          |
| `LOCKED`  | Blocks access after three incorrect attempts                       |

---

## 🔑 Password Verification

For demonstration purposes, the current password is:

```text
1011011001
```

The password is defined in VHDL as:

```vhdl
constant password : std_logic_vector(9 downto 0)
    := "1011011001";
```

The entered switch value is compared directly with the stored password:

```vhdl
if switch = password then
    state <= GRANTED;
else
    state <= WRONG;
end if;
```

---

## 🚦 LED Status

The three LEDs indicate the current system status.

| LED[2:0] | Status            |
| -------- | ----------------- |
| `000`    | Waiting for input |
| `001`    | Access granted    |
| `100`    | Wrong password    |
| `010`    | System locked     |

---

## 🛠️ Hardware

### FPGA Board

**Terasic DE10-Standard**

* Intel Cyclone V FPGA
* 50 MHz system clock
* 10 user switches
* Push buttons
* User LEDs

### Development Tools

* Intel Quartus Prime Lite 18.1
* VHDL
* ModelSim Intel FPGA Edition
* Git / GitHub

---

## ⚙️ Clock

The design uses the DE10-Standard 50 MHz clock.

The corresponding clock period is:

```text
T = 1 / 50 MHz = 20 ns
```

The timing constraint is defined in the SDC file:

```tcl
create_clock -name CLOCK_50 -period 20.000 [get_ports {clock}]
```

---

## 📚 What I Learned

This project provided practical experience with:

* VHDL design
* Finite State Machines
* Sequential logic
* Clocked processes
* State transitions
* Password comparison
* Counter-based control logic
* FPGA pin assignments
* Timing constraints
* Quartus compilation
* Hardware testing

---

## 👨‍💻 Author

**Ghassen Mahmoud**

Master 2 – Electronics and Embedded Systems
ESIGELEC, France

Interests:

`FPGA` · `VHDL` · `Embedded Systems` · `STM32` · `C/C++` · `Digital Design`
