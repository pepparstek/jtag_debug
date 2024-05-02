package debug_pkg;

  // Implementation built using 
  //
  // The RISC-V Deubg Specification
  // Tim Newsome, Paul Donahue (Ventana Micro Systems)
  // Version 1.0.0-rc2, Revised 2024-01-25: Frozen


  // ########################################################
  // #               Debug Transport Module                 #
  // ########################################################

  // 6.1.4. DTM Control and Status (dtmcs, at 0x10)
  // Struct representing the DTM
  typedef struct packed {
    logic [31:21] zero;  // msb
    logic [20:18] errinfo;  // 
    logic dtmhardreset;
    logic dmireset;
    logic zero_;
    logic [14:12] idle;
    logic [11:10] dmistat;
    logic [9:4] abits;
    logic [3:0] version;  // lsb
  } dtmcs_t;

  // 6.1.4. DTM Control and Status (dtmcs, at 0x10)
  // DTMCS ERRINFO
  typedef enum logic [2:0] {
    DTMNoImpl = 3'h0,
    DMIErr    = 3'h1,   // Error between DTM and DMI
    CommErr   = 3'h2,   // Error between DMI and DMI subordinate
    DeviceErr = 3'h3,   // DMI subordinate reported an error
    Unknown   = 3'h4    // Reset value. No error to report
  } dtmcs_errinfo_e;











  // ########################################################
  // #                Debug Module Interface                #
  // ########################################################

  // 6.1.5. Debug Module Interface Access (dmi, at 0x11)
  // Struct representing DMI data package.
  typedef struct packed {
    logic [39:34] address;  // msb // Address to access
    logic [33:2]  data;     // Data to read/write
    logic [1:0]   op;       // lsb // Operation to perform. See dmi_op_e
  } dmi_t;

  // 6.1.5. Debug Module Interface Access (dmi, at 0x11)
  // Operations by the DMI
  typedef enum logic [1:0] {
    DMINop = 'h0,
    DMIRead = 'h1,
    DMIWrite = 'h2,
    DMIReserved = 'h3
  } dmi_op_e;

  // 6.1.5. Debug Module Interface Access (dmi, at 0x11)
  // When debugger reads op field
  typedef enum logic [1:0] {
    DMINoError = 2'h0,
    DMIReservedError = 2'h1,
    DMIOpFailed = 2'h2,
    DMIBusy = 2'h3
  } dmi_error_e;

  // A.3. Debug Module Interface Signals
  typedef struct {
    logic DTM_RSP_READY;  // DTM: Able to process a response
    logic DTM_REQ_VALID;  // DTM: Valid request pending
    logic DM_REQ_READY;   // DM: Able to process a request
    logic DM_RSP_VALID;   // DM: Valid respond pending
  } dmi_interface_signals_t;

  typedef enum logic [2:0] {
    Idle = 2'h0,
    Read = 2'h1,
    Write = 2'h2,
    WaitResponse = 2'h3
  } dmi_state_e;










  // ########################################################
  // #                      Debug Module                    #
  // ########################################################

  // 3.14.1. Debug Module Status (dmstatus, at 0x11)
  // Status of the overall Debug Module and about the
  // currently selected harts
  typedef struct packed {
    logic [31:25] zero;  // msb
    logic ndmresetpending;
    logic stickyunavail;
    logic impebreak;
    logic [21:20] zero_;
    logic allhavereset;
    logic anyhavereset;
    logic allresumeack;
    logic anyresumeack;
    logic allnonexistent;
    logic anynonexistent;
    logic allunavail;
    logic anyunavail;
    logic allrunning;
    logic anyrunning;
    logic anyhalted;
    logic authenticated;
    logic authbusy;
    logic hasresethaltreq;
    logic confstrptrvalid;
    logic [3:0] version;  // lsb
  } dmstatus_t;

  // 3.14.2. Debug Module Control (dmcontrol, at 0x10)
  // Controls the currently selected currently selected harts.
  typedef struct packed {
    logic haltreq;  // msb
    logic resumereq;
    logic hartreset;
    logic ackhavereset;
    logic ackunavail;
    logic hasel;
    logic [25:16] hartsello;
    logic [15:6] hartselhi;
    logic setkeepalive;
    logic clrkeepalive;
    logic setresethaltreq;
    logic clrresethaltreq;
    logic ndmreset;
    logic dmactive;  // lsb
  } dmcontrol_t;
    
  // 3.14. Debug Module Registers
  typedef struct {
    dmcontrol_t dmcontrol;
    dmstatus_t  dmstatus;
  } dm_t;


endpackage
