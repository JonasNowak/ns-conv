/* ==========================================================================
   ns-conv: Interactive 3D WebGL Cyberdeck Studio & Complete 10-Phase Guide App
   File: docs/assets/app.js
   ========================================================================== */

(function () {
  "use strict";

  // --------------------------------------------------------------------------
  // 1. Metadata: 6 Premade SLA Factory Color Options & Navigation Items
  // --------------------------------------------------------------------------
  const SLA_COLOR_PRESETS = [
    {
      id: "lilac",
      name: "Translucent Lilac (PCBWay UTR-8100 + Pantone 2577 C)",
      price: "€145.00",
      shellHex: 0xbd93f9,
      trimHex: 0xa678e8,
      swatchCss: "linear-gradient(135deg, #d6b4ff 0%, #9d65e5 100%)",
      transparent: true,
      opacity: 0.76,
      transmission: 0.38,
      roughness: 0.18,
      metalness: 0.04,
      clearcoat: 0.85,
    },
    {
      id: "clear",
      name: "Translucent Clear Ice (JLC3DP 8001 + Clear Spray)",
      price: "€50.00",
      shellHex: 0xdff4ff,
      trimHex: 0xc8e9ff,
      swatchCss: "linear-gradient(135deg, #ffffff 0%, #9be2ff 100%)",
      transparent: true,
      opacity: 0.64,
      transmission: 0.52,
      roughness: 0.14,
      metalness: 0.02,
      clearcoat: 0.92,
    },
    {
      id: "white",
      name: "Opaque Matte White / Ivory (JLC3DP 9000R)",
      price: "€26.00",
      shellHex: 0xeceff4,
      trimHex: 0xd8dee9,
      swatchCss: "#eceff4",
      transparent: false,
      opacity: 1.0,
      transmission: 0.0,
      roughness: 0.55,
      metalness: 0.05,
      clearcoat: 0.1,
    },
    {
      id: "grey",
      name: "Opaque Matte Gunmetal Grey (JLC3DP 8111X)",
      price: "€28.00",
      shellHex: 0x4c566a,
      trimHex: 0x3b4252,
      swatchCss: "#4c566a",
      transparent: false,
      opacity: 1.0,
      transmission: 0.0,
      roughness: 0.52,
      metalness: 0.12,
      clearcoat: 0.12,
    },
    {
      id: "black",
      name: "Opaque Stealth Matte Black (JLC3DP Imagine Black)",
      price: "€30.00",
      shellHex: 0x1e222d,
      trimHex: 0x151821,
      swatchCss: "#1e222d",
      transparent: false,
      opacity: 1.0,
      transmission: 0.0,
      roughness: 0.48,
      metalness: 0.1,
      clearcoat: 0.15,
    },
    {
      id: "skyblue",
      name: "Factory Painted Sky Blue (JLC3DP 9000R Painted)",
      price: "€58.00",
      shellHex: 0x5ccfe6,
      trimHex: 0x36a3d9,
      swatchCss: "linear-gradient(135deg, #7dcfff 0%, #2ac3de 100%)",
      transparent: false,
      opacity: 1.0,
      transmission: 0.0,
      roughness: 0.32,
      metalness: 0.08,
      clearcoat: 0.65,
    },
  ];

  const GUIDE_META = [
    { key: "overview", badge: "HOME", title: "Project Overview & Architecture", path: "README.md" },
    { key: "phase1_research", badge: "P1", title: "Research & Prior Art", path: "docs/research.md" },
    { key: "phase2_bom", badge: "P2", title: "Bill of Materials (EUR BOM)", path: "docs/bom.md" },
    { key: "phase3_teardown", badge: "P3", title: "Non-Destructive Teardown", path: "docs/teardown.md" },
    { key: "phase4_wiring", badge: "P4", title: "Electronics, Hub & 15V PD Wiring", path: "docs/wiring.md" },
    { key: "phase5_cad", badge: "P5", title: "Parametric OpenSCAD Overview", path: "docs/cad-overview.md" },
    { key: "phase6_print", badge: "P6", title: "3D Print Spec (6 Premade Colors)", path: "docs/print-spec.md" },
    { key: "phase7_assembly", badge: "P7", title: "Step-by-Step Assembly Guide", path: "docs/assembly.md" },
    { key: "phase8_software", badge: "P8", title: "Software: chimera-l4s 6.18 + Kefir", path: "docs/software.md" },
    { key: "phase9_testing", badge: "P9", title: "Test & Acceptance Checklist", path: "docs/testing.md" },
    { key: "phase10_risks", badge: "P10", title: "Top 10 Engineering Risk Register", path: "docs/risks.md" },
    { key: "datasheets", badge: "REF", title: "Component Datasheets & Specs", path: "hardware/datasheets.md" },
    { key: "scad_explorer", badge: "CAD", title: "OpenSCAD Source Code & STLs", path: "cad/*.scad" },
  ];

  // 3D Callout Pins in OpenSCAD (X, Y, Z) coordinates
  const CALLOUT_DEFS = [
    { label: "Switch v1 Core (6.2\" LCD + T210)", pos: [0, 81, 35], group: "lid", docKey: "phase3_teardown" },
    { label: "Drop × MIT Planck (47-Key 6KRO)", pos: [-30, 58, 28], group: "base", docKey: "phase4_wiring" },
    { label: "38mm QMK Trackball + 3× MR63ZZ", pos: [106, 62, 42], group: "base", docKey: "phase5_cad" },
    { label: "INIU 45W 15V PD Bank (UN 38.3)", pos: [-80, 54, 14], group: "base", docKey: "phase4_wiring" },
    { label: "Exposed USB-A 3.0 + 4K HDMI", pos: [153, 118, 12], group: "base", docKey: "phase7_assembly" },
    { label: "Southco E6-10-301 Torque Hinges", pos: [-95, 156, 28], group: "base", docKey: "phase5_cad" },
    { label: "Rear USB-C Coupler (RCM / usb0 SSH)", pos: [0, 162, 16], group: "base", docKey: "phase8_software" },
    { label: "Recessed RCM Boot Trigger (Pin 10)", pos: [118, 30, 35], group: "lid", docKey: "phase8_software" },
  ];

  // State
  let currentGuideKey = "overview";
  let currentColorPreset = SLA_COLOR_PRESETS[0];
  let currentPartFilter = "full"; // 'full' or STL name
  let lidAngleDeg = 112;
  let explodeAmount = 0;
  let wireframeEnabled = false;
  let autoSpinEnabled = false;
  let calloutsEnabled = true;
  let screenModeIndex = 0; // 0 = Chimera Linux 6.18, 1 = Hekate Nyx, 2 = Horizon OS

  // Three.js references
  let scene, camera, renderer, controls;
  let cadRoot, fullAssemblyGroup, singlePartGroup;
  let lidPivotGroup, topDeckGroup, lidBezelGroup, batteryStrapGroup;
  let shellMeshes = [];
  let trimMeshes = [];
  let allCadMeshes = [];
  let parsedGeometries = {};
  let switchScreenTexture, switchScreenCtx, switchScreenCanvas;
  let calloutEls = [];

  // --------------------------------------------------------------------------
  // 2. Binary STL Decompressor & BufferGeometry Parser
  // --------------------------------------------------------------------------
  async function gunzipBase64ToArrayBuffer(b64) {
    const binaryStr = atob(b64);
    const bytes = new Uint8Array(binaryStr.length);
    for (let i = 0; i < binaryStr.length; i++) {
      bytes[i] = binaryStr.charCodeAt(i);
    }
    if (typeof DecompressionStream !== "undefined") {
      const ds = new DecompressionStream("gzip");
      const writer = ds.writable.getWriter();
      writer.write(bytes);
      writer.close();
      const resp = new Response(ds.readable);
      return await resp.arrayBuffer();
    }
    throw new Error("DecompressionStream unavailable");
  }

  function parseBinarySTL(buffer) {
    const dv = new DataView(buffer);
    const numTriangles = dv.getUint32(80, true);
    const positions = new Float32Array(numTriangles * 9);
    const normals = new Float32Array(numTriangles * 9);

    let offset = 84;
    for (let i = 0; i < numTriangles; i++) {
      const nx = dv.getFloat32(offset, true);
      const ny = dv.getFloat32(offset + 4, true);
      const nz = dv.getFloat32(offset + 8, true);

      const baseIdx = i * 9;
      for (let v = 0; v < 3; v++) {
        const vOff = offset + 12 + v * 12;
        positions[baseIdx + v * 3] = dv.getFloat32(vOff, true);
        positions[baseIdx + v * 3 + 1] = dv.getFloat32(vOff + 4, true);
        positions[baseIdx + v * 3 + 2] = dv.getFloat32(vOff + 8, true);

        normals[baseIdx + v * 3] = nx;
        normals[baseIdx + v * 3 + 1] = ny;
        normals[baseIdx + v * 3 + 2] = nz;
      }
      offset += 50;
    }

    const geom = new THREE.BufferGeometry();
    geom.setAttribute("position", new THREE.BufferAttribute(positions, 3));
    geom.setAttribute("normal", new THREE.BufferAttribute(normals, 3));
    geom.computeVertexNormals();
    return geom;
  }

  async function loadAllSTLGeometries() {
    const names = [
      "base_bottom",
      "base_top_deck",
      "lid_rear",
      "lid_bezel",
      "battery_retainer",
      "cable_clamp",
      "test_fit_jig",
    ];
    for (const name of names) {
      let buf = null;
      if (window.NS_CONV_MODELS_GZ_B64 && window.NS_CONV_MODELS_GZ_B64[name]) {
        try {
          buf = await gunzipBase64ToArrayBuffer(window.NS_CONV_MODELS_GZ_B64[name]);
        } catch (e) {
          console.warn("Fallback to fetch for", name, e);
        }
      }
      if (!buf) {
        const resp = await fetch(`models/${name}.stl`);
        buf = await resp.arrayBuffer();
      }
      parsedGeometries[name] = parseBinarySTL(buf);
    }
  }

  // --------------------------------------------------------------------------
  // 3. Dynamic Switch 6.2" IPS Screen Canvas Texture (Chimera 6.18 / Hekate / HOS)
  // --------------------------------------------------------------------------
  function createSwitchScreenTexture() {
    switchScreenCanvas = document.createElement("canvas");
    switchScreenCanvas.width = 1024;
    switchScreenCanvas.height = 576;
    switchScreenCtx = switchScreenCanvas.getContext("2d");
    switchScreenTexture = new THREE.CanvasTexture(switchScreenCanvas);
    switchScreenTexture.encoding = THREE.sRGBEncoding;
    drawSwitchScreenContent(0);
    return switchScreenTexture;
  }

  function drawSwitchScreenContent(mode) {
    const ctx = switchScreenCtx;
    const w = switchScreenCanvas.width;
    const h = switchScreenCanvas.height;

    if (mode === 0) {
      // Chimera Linux 6.18.0-enigma-r20-erista+ Terminal HUD
      ctx.fillStyle = "#090c14";
      ctx.fillRect(0, 0, w, h);

      // Top status bar
      ctx.fillStyle = "#1a1f33";
      ctx.fillRect(0, 0, w, 40);
      ctx.fillStyle = "#bd93f9";
      ctx.font = "bold 20px monospace";
      ctx.fillText("CHIMERA LINUX aarch64 // 6.18.0-enigma-r20-erista+ (Tegra210 icosa)", 20, 27);
      ctx.fillStyle = "#73daca";
      ctx.fillText("15V PD [53.0Wh 98%]  usb0: 10.42.0.2", 615, 27);

      const lines = [
        { c: "#7dcfff", t: "chimera@chimera-switch ~ $ uname -a" },
        { c: "#e0e6ff", t: "Linux chimera-switch 6.18.0-enigma-r20-erista+ #1 SMP PREEMPT aarch64" },
        { c: "#7dcfff", t: "chimera@chimera-switch ~ $ cat /sys/firmware/devicetree/base/model" },
        { c: "#73daca", t: "Nintendo Switch (Erista / Tegra210 ODIN SKU 0x4F44494E)" },
        { c: "#7dcfff", t: "chimera@chimera-switch ~ $ lsusb && dinitctl list" },
        { c: "#e0e6ff", t: "Bus 001 Device 002: ID 2109:2817 VIA Labs USB 3.0 Hub (100W PD)" },
        { c: "#bd93f9", t: "Bus 001 Device 003: ID 03eb:2ff4 OLKB Drop x MIT Planck Keyboard (6KRO)" },
        { c: "#bd93f9", t: "Bus 001 Device 004: ID 5043:5442 Ploopy Nano 2 QMK Trackball (PMW3360)" },
        { c: "#73daca", t: "[{+} started] boot          [{+} started] usb-gadget (CDC-NCM 10.42.0.2)" },
        { c: "#73daca", t: "[{+} started] sshd (port 22) [{+} started] local" },
        { c: "#e0af68", t: "chimera@chimera-switch ~ $ _  [Ready — Type on Planck or SSH 10.42.0.2]" },
      ];
      ctx.font = "21px monospace";
      lines.forEach((ln, idx) => {
        ctx.fillStyle = ln.c;
        ctx.fillText(ln.t, 24, 82 + idx * 42);
      });
    } else if (mode === 1) {
      // Hekate v6.2 Nyx Bootloader GUI
      const grad = ctx.createLinearGradient(0, 0, w, h);
      grad.addColorStop(0, "#111625");
      grad.addColorStop(1, "#231938");
      ctx.fillStyle = grad;
      ctx.fillRect(0, 0, w, h);

      ctx.fillStyle = "#bd93f9";
      ctx.font = "bold 26px sans-serif";
      ctx.fillText("hekate v6.2.x - NYX GUI  //  ns-conv Multi-Boot Selector", 36, 54);

      const cards = [
        { title: "Kefir CFW", sub: "emuMMC (Exosphere + dns.mitm)", col: "#7dcfff", x: 50 },
        { title: "Chimera Linux 6.18", sub: "Enigma R20 (SWR-CHI ext4)", col: "#bd93f9", x: 365 },
        { title: "Stock Horizon OS", sub: "Clean sysNAND (Online Safe)", col: "#73daca", x: 680 },
      ];
      cards.forEach((c) => {
        ctx.fillStyle = "rgba(255,255,255,0.07)";
        ctx.strokeStyle = c.col;
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.roundRect(c.x, 120, 290, 320, 18);
        ctx.fill();
        ctx.stroke();

        ctx.fillStyle = c.col;
        ctx.font = "bold 26px sans-serif";
        ctx.fillText(c.title, c.x + 28, 260);
        ctx.fillStyle = "#c0caf5";
        ctx.font = "18px monospace";
        ctx.fillText(c.sub, c.x + 22, 305);
      });

      ctx.fillStyle = "#a9b1d6";
      ctx.font = "19px monospace";
      ctx.fillText("Touchscreen & 38mm Trackball Active  |  SoC: 36°C  |  15V USB-C PD Charging", 36, 520);
    } else {
      // Horizon OS Mode
      const grad = ctx.createLinearGradient(0, 0, 0, h);
      grad.addColorStop(0, "#1c202b");
      grad.addColorStop(1, "#13161f");
      ctx.fillStyle = grad;
      ctx.fillRect(0, 0, w, h);

      ctx.fillStyle = "#ffffff";
      ctx.font = "bold 24px sans-serif";
      ctx.fillText("Nintendo Switch Horizon OS  •  15V PD ⚡ 100%  •  Wi-Fi 5GHz ▂▄▆█", 38, 52);

      const tiles = ["#f7768e", "#7dcfff", "#bd93f9", "#73daca"];
      tiles.forEach((col, i) => {
        ctx.fillStyle = col;
        ctx.beginPath();
        ctx.roundRect(52 + i * 235, 115, 205, 280, 14);
        ctx.fill();
      });

      ctx.fillStyle = "#e0e6ff";
      ctx.font = "20px monospace";
      ctx.fillText("USB HID Keyboard (Drop x MIT Planck 6KRO) + Wireless Joy-Con Ready", 52, 485);
    }

    if (switchScreenTexture) {
      switchScreenTexture.needsUpdate = true;
    }
  }

  // --------------------------------------------------------------------------
  // 4. Construct 3D Scene & Exact OpenSCAD Clamshell Assembly
  // --------------------------------------------------------------------------
  function createShellMaterial(isTrim) {
    const p = currentColorPreset;
    return new THREE.MeshPhysicalMaterial({
      color: isTrim ? p.trimHex : p.shellHex,
      transparent: p.transparent,
      opacity: p.opacity,
      transmission: p.transmission,
      roughness: p.roughness,
      metalness: p.metalness,
      clearcoat: p.clearcoat,
      clearcoatRoughness: 0.12,
      ior: 1.51,
      side: THREE.DoubleSide,
      wireframe: wireframeEnabled,
    });
  }

  function applyColorPreset(preset) {
    currentColorPreset = preset;
    shellMeshes.forEach((m) => {
      m.material.color.setHex(preset.shellHex);
      m.material.transparent = preset.transparent;
      m.material.opacity = preset.opacity;
      m.material.transmission = preset.transmission;
      m.material.roughness = preset.roughness;
      m.material.metalness = preset.metalness;
      m.material.clearcoat = preset.clearcoat;
      m.material.needsUpdate = true;
    });
    trimMeshes.forEach((m) => {
      m.material.color.setHex(preset.trimHex);
      m.material.transparent = preset.transparent;
      m.material.opacity = preset.transparent ? Math.min(1, preset.opacity + 0.08) : 1.0;
      m.material.transmission = preset.transmission * 0.8;
      m.material.roughness = preset.roughness;
      m.material.metalness = preset.metalness;
      m.material.clearcoat = preset.clearcoat;
      m.material.needsUpdate = true;
    });

    const labelEl = document.getElementById("active-swatch-name");
    const priceEl = document.getElementById("active-swatch-price");
    if (labelEl) labelEl.textContent = preset.name;
    if (priceEl) priceEl.textContent = preset.price;
  }

  function buildDonorPlanckKeyboard() {
    const group = new THREE.Group();
    // Matches cad/assembly_preview.scad: translate([planck_x0=-141, planck_y0=18, z=24.5])
    group.position.set(-141.0, 18.0, 24.5);

    // 1.5mm Anodized Switch Plate (233 x 81 x 1.5mm)
    const plateGeom = new THREE.BoxGeometry(233.0, 81.0, 1.5);
    plateGeom.translate(233.0 / 2, 81.0 / 2, 0.75);
    const plateMat = new THREE.MeshStandardMaterial({
      color: 0x2a2e3d,
      roughness: 0.4,
      metalness: 0.7,
    });
    group.add(new THREE.Mesh(plateGeom, plateMat));

    // 4x12 Ortholinear Sculpted Keycaps (47 keys with 2u MIT Spacebar)
    const pitch = 19.05;
    const xStart = (233.0 - 12 * pitch) / 2;
    const yStart = (81.0 - 4 * pitch) / 2;

    const matAlpha = new THREE.MeshStandardMaterial({ color: 0xe5e9f0, roughness: 0.35 });
    const matMod = new THREE.MeshStandardMaterial({ color: 0x434c5e, roughness: 0.38 });
    const matSpace = new THREE.MeshStandardMaterial({ color: 0x9d65e5, roughness: 0.3 });

    for (let r = 0; r < 4; r++) {
      for (let c = 0; c < 12; c++) {
        if (r === 0 && c === 6) continue; // 2u MIT spacebar occupies col 5 & 6
        const isSpace = r === 0 && c === 5;
        const isMod = r === 0 || c === 0 || c === 11;
        const kw = isSpace ? 2 * pitch - 2.0 : pitch - 2.0;
        const kh = pitch - 2.0;

        const capGeom = new THREE.BoxGeometry(kw, kh, 7.2);
        const cx = xStart + c * pitch + 1.0 + kw / 2;
        const cy = yStart + (3 - r) * pitch + 1.0 + kh / 2;
        capGeom.translate(cx, cy, 1.5 + 3.6);

        const capMesh = new THREE.Mesh(
          capGeom,
          isSpace ? matSpace : isMod ? matMod : matAlpha
        );
        group.add(capMesh);
      }
    }
    return group;
  }

  function buildDonorSwitchCore() {
    const group = new THREE.Group();
    // Matches cad/assembly_preview.scad: translate([-83.25, 30.0, 15.0 - 11.8 - 1.25])
    group.position.set(-83.25, 30.0, 1.95);

    // Magnesium & black glass body (166.5 x 102.0 x 11.8 mm)
    const bodyGeom = new THREE.BoxGeometry(166.5, 102.0, 11.8);
    bodyGeom.translate(166.5 / 2, 102.0 / 2, 11.8 / 2);
    const bodyMat = new THREE.MeshStandardMaterial({
      color: 0x1a1d26,
      roughness: 0.35,
      metalness: 0.45,
    });
    group.add(new THREE.Mesh(bodyGeom, bodyMat));

    // Active 6.2" IPS Screen Plane (137.4 x 77.6 mm)
    const tex = createSwitchScreenTexture();
    const lcdGeom = new THREE.PlaneGeometry(137.4, 77.6);
    const lcdMat = new THREE.MeshBasicMaterial({
      map: tex,
      side: THREE.DoubleSide,
    });
    const lcdMesh = new THREE.Mesh(lcdGeom, lcdMat);
    lcdMesh.position.set(166.5 / 2, 102.0 / 2, 12.15);
    group.add(lcdMesh);

    return group;
  }

  function buildInternalBaseComponents() {
    const group = new THREE.Group();

    // 1. INIU 45W Slim 15V PD Power Bank (110 x 68 x 18.5 mm)
    const pbGeom = new THREE.BoxGeometry(110.0, 68.0, 18.5);
    pbGeom.translate(-153.0 + 18.5 + 55.0, 20.5 + 34.0, 4.0 + 18.5 / 2);
    const pbMat = new THREE.MeshStandardMaterial({
      color: 0x202534,
      roughness: 0.4,
      metalness: 0.3,
    });
    group.add(new THREE.Mesh(pbGeom, pbMat));

    // 2. UGREEN 100W 5-in-1 USB-C PD Hub (115 x 27.5 x 12.2 mm) aligned with right-side USB-A/HDMI window
    const hubGeom = new THREE.BoxGeometry(115.0, 27.5, 12.2);
    hubGeom.translate(22.0 + 115.0 / 2, 105.0 + 27.5 / 2, 2.5 + 12.2 / 2);
    const hubMat = new THREE.MeshStandardMaterial({
      color: 0x3b4252,
      roughness: 0.3,
      metalness: 0.75,
    });
    group.add(new THREE.Mesh(hubGeom, hubMat));

    // 3. Southco E6-10-301-20 Adjustable Friction Torque Hinges (Left & Right at X = ±95mm)
    const hingeMat = new THREE.MeshStandardMaterial({
      color: 0x181a22,
      roughness: 0.35,
      metalness: 0.6,
    });
    [-95.0, 95.0].forEach((hx) => {
      const leafGeom = new THREE.BoxGeometry(42.9, 16.0, 3.2);
      leafGeom.translate(hx, 162.0 - 8.0, 24.5 - 1.6);
      group.add(new THREE.Mesh(leafGeom, hingeMat));

      const barrelGeom = new THREE.CylinderGeometry(5.2, 5.2, 42.9, 24);
      barrelGeom.rotateZ(Math.PI / 2);
      barrelGeom.translate(hx, 156.0, 26.5);
      group.add(new THREE.Mesh(barrelGeom, hingeMat));
    });

    // 4. 90-Degree Flat USB-C Hinge Ribbon Loop at X = 0
    const ribGeom = new THREE.BoxGeometry(14.0, 18.0, 1.2);
    ribGeom.translate(0, 154.0, 24.0);
    const ribMat = new THREE.MeshStandardMaterial({ color: 0xe0af68, roughness: 0.4, metalness: 0.5 });
    group.add(new THREE.Mesh(ribGeom, ribMat));

    return group;
  }

  function buildSceneAssembly() {
    shellMeshes = [];
    trimMeshes = [];
    allCadMeshes = [];

    cadRoot = new THREE.Group();
    // Convert OpenSCAD Z-up to Three.js Y-up and center at (0, 0, 0)
    cadRoot.rotation.x = -Math.PI / 2;
    cadRoot.position.set(0, -18, 75);
    scene.add(cadRoot);

    fullAssemblyGroup = new THREE.Group();
    cadRoot.add(fullAssemblyGroup);

    singlePartGroup = new THREE.Group();
    singlePartGroup.visible = false;
    cadRoot.add(singlePartGroup);

    // 1. base_bottom.stl
    const matShell1 = createShellMaterial(false);
    const meshBaseBottom = new THREE.Mesh(parsedGeometries.base_bottom, matShell1);
    shellMeshes.push(meshBaseBottom);
    allCadMeshes.push(meshBaseBottom);
    fullAssemblyGroup.add(meshBaseBottom);

    // 2. Internal Base Hardware (Power Bank, Hub, Hinges, Ribbon)
    fullAssemblyGroup.add(buildInternalBaseComponents());

    // 3. battery_retainer.stl & lower cable_clamp.stl
    batteryStrapGroup = new THREE.Group();
    const matTrim1 = createShellMaterial(true);
    const meshBatRet = new THREE.Mesh(parsedGeometries.battery_retainer, matTrim1);
    meshBatRet.position.set(-153.0 + 18.0 + 55.0, 20.0 + 34.5, 22.5);
    trimMeshes.push(meshBatRet);
    allCadMeshes.push(meshBatRet);
    batteryStrapGroup.add(meshBatRet);

    const meshClampLow = new THREE.Mesh(parsedGeometries.cable_clamp, matTrim1.clone());
    meshClampLow.position.set(0, 146.0, 6.0);
    trimMeshes.push(meshClampLow);
    allCadMeshes.push(meshClampLow);
    batteryStrapGroup.add(meshClampLow);
    fullAssemblyGroup.add(batteryStrapGroup);

    // 4. Top Deck Group (base_top_deck.stl + Drop Planck + 38mm Trackball + 3x MR63ZZ Bearings)
    topDeckGroup = new THREE.Group();
    const matTrim2 = createShellMaterial(true);
    const meshTopDeck = new THREE.Mesh(parsedGeometries.base_top_deck, matTrim2);
    meshTopDeck.position.set(0, 0, 24.5);
    trimMeshes.push(meshTopDeck);
    allCadMeshes.push(meshTopDeck);
    topDeckGroup.add(meshTopDeck);

    // Drop x MIT Planck 47-Key Keyboard
    topDeckGroup.add(buildDonorPlanckKeyboard());

    // 38mm Glossy Crimson/Purple Trackball + 3x MR63ZZ Steel Roller Bearings
    const ballGeom = new THREE.SphereGeometry(19.0, 40, 40);
    const ballMat = new THREE.MeshPhysicalMaterial({
      color: 0xd92648,
      roughness: 0.08,
      metalness: 0.1,
      clearcoat: 1.0,
      clearcoatRoughness: 0.04,
    });
    const meshBall = new THREE.Mesh(ballGeom, ballMat);
    meshBall.position.set(106.0, 62.0, 27.0);
    topDeckGroup.add(meshBall);

    const brgMat = new THREE.MeshStandardMaterial({ color: 0xd8dee9, metalness: 0.9, roughness: 0.2 });
    [0, 120, 240].forEach((deg) => {
      const rad = THREE.MathUtils.degToRad(deg);
      const bGeom = new THREE.CylinderGeometry(3.0, 3.0, 2.5, 16);
      const bMesh = new THREE.Mesh(bGeom, brgMat);
      bMesh.position.set(106.0 + 15.5 * Math.cos(rad), 62.0 + 15.5 * Math.sin(rad), 16.5);
      topDeckGroup.add(bMesh);
    });

    fullAssemblyGroup.add(topDeckGroup);

    // 5. Upper Lid Pivot Group (Rotates around Hinge Axis Y=156.0, Z=28.5)
    lidPivotGroup = new THREE.Group();
    lidPivotGroup.position.set(0, 156.0, 28.5);
    fullAssemblyGroup.add(lidPivotGroup);

    const lidInnerOffset = new THREE.Group();
    lidInnerOffset.position.set(0, -6.0, -17.7);
    lidPivotGroup.add(lidInnerOffset);

    // lid_rear.stl
    const matShell2 = createShellMaterial(false);
    const meshLidRear = new THREE.Mesh(parsedGeometries.lid_rear, matShell2);
    shellMeshes.push(meshLidRear);
    allCadMeshes.push(meshLidRear);
    lidInnerOffset.add(meshLidRear);

    // Donor Switch v1 Core + 6.2" LCD
    lidInnerOffset.add(buildDonorSwitchCore());

    // lid_bezel.stl
    lidBezelGroup = new THREE.Group();
    const matTrim3 = createShellMaterial(true);
    const meshLidBezel = new THREE.Mesh(parsedGeometries.lid_bezel, matTrim3);
    meshLidBezel.position.set(0, 0, 15.0);
    trimMeshes.push(meshLidBezel);
    allCadMeshes.push(meshLidBezel);
    lidBezelGroup.add(meshLidBezel);
    lidInnerOffset.add(lidBezelGroup);

    updateLidAndExplodeTransforms();
  }

  function updateLidAndExplodeTransforms() {
    if (!lidPivotGroup) return;
    // Lid rotation: at 112 deg open, rotate([180 - 112, 0, 0]) = 68 deg
    lidPivotGroup.rotation.x = THREE.MathUtils.degToRad(180 - lidAngleDeg);
    lidPivotGroup.position.set(0, 156.0, 28.5 + explodeAmount * 1.4);

    if (topDeckGroup) {
      topDeckGroup.position.set(0, 0, explodeAmount * 0.75);
    }
    if (batteryStrapGroup) {
      batteryStrapGroup.position.set(0, 0, explodeAmount * 0.35);
    }
    if (lidBezelGroup) {
      lidBezelGroup.position.set(0, 0, explodeAmount * 0.65);
    }
  }

  function selectPartView(partId) {
    currentPartFilter = partId;
    document.querySelectorAll(".part-chip").forEach((btn) => {
      btn.classList.toggle("active", btn.dataset.part === partId);
    });

    const dlBtn = document.getElementById("download-stl-btn");
    if (partId === "full") {
      fullAssemblyGroup.visible = true;
      singlePartGroup.visible = false;
      if (dlBtn) {
        dlBtn.href = "models/base_bottom.stl";
        dlBtn.textContent = "⬇ Download .STL (base_bottom)";
      }
      return;
    }

    // Isolate single STL part in singlePartGroup
    fullAssemblyGroup.visible = false;
    singlePartGroup.visible = true;
    while (singlePartGroup.children.length > 0) {
      singlePartGroup.remove(singlePartGroup.children[0]);
    }

    const geom = parsedGeometries[partId];
    if (geom) {
      geom.computeBoundingBox();
      const box = geom.boundingBox;
      const center = new THREE.Vector3();
      box.getCenter(center);

      const mat = createShellMaterial(false);
      const mesh = new THREE.Mesh(geom, mat);
      mesh.position.set(-center.x, 81 - center.y, 18 - center.z);
      shellMeshes.push(mesh);
      allCadMeshes.push(mesh);
      singlePartGroup.add(mesh);
    }

    if (dlBtn) {
      dlBtn.href = `models/${partId}.stl`;
      dlBtn.textContent = `⬇ Download ${partId}.stl`;
    }
  }

  // --------------------------------------------------------------------------
  // 5. Initialize Three.js WebGL Renderer & OrbitControls
  // --------------------------------------------------------------------------
  async function init3DViewer() {
    const container = document.getElementById("webgl-container");
    const width = container.clientWidth || 640;
    const height = container.clientHeight || 520;

    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera(36, width / height, 1, 3000);
    camera.position.set(275, 225, 345);

    renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.15;
    container.innerHTML = "";
    container.appendChild(renderer.domElement);

    // Studio 3-Point Lighting + Subtle Reference Grid
    const ambient = new THREE.AmbientLight(0xd8dee9, 0.85);
    scene.add(ambient);

    const keyLight = new THREE.DirectionalLight(0xffffff, 1.35);
    keyLight.position.set(220, 380, 260);
    scene.add(keyLight);

    const fillLight = new THREE.DirectionalLight(0xbd93f9, 0.65);
    fillLight.position.set(-280, 180, -180);
    scene.add(fillLight);

    const rimLight = new THREE.DirectionalLight(0x7dcfff, 0.55);
    rimLight.position.set(0, -200, 220);
    scene.add(rimLight);

    const grid = new THREE.GridHelper(460, 23, 0xbd93f9, 0x23283d);
    grid.position.y = -19;
    grid.material.opacity = 0.35;
    grid.material.transparent = true;
    scene.add(grid);

    controls = new THREE.OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.06;
    controls.target.set(0, 22, 0);
    controls.minDistance = 90;
    controls.maxDistance = 950;

    await loadAllSTLGeometries();
    buildSceneAssembly();
    initCalloutPins();

    window.addEventListener("resize", onWindowResize);
    animate();
  }

  function initCalloutPins() {
    const layer = document.getElementById("callout-layer");
    if (!layer) return;
    layer.innerHTML = "";
    calloutEls = CALLOUT_DEFS.map((def) => {
      const el = document.createElement("div");
      el.className = "callout-pin";
      el.textContent = def.label;
      el.title = "Click to open engineering guide section";
      el.addEventListener("click", () => {
        renderGuide(def.docKey);
      });
      layer.appendChild(el);
      return { el, def };
    });
  }

  function updateCalloutPinPositions() {
    const layer = document.getElementById("callout-layer");
    if (!layer) return;
    const show = calloutsEnabled && currentPartFilter === "full";
    layer.style.display = show ? "block" : "none";
    if (!show || !cadRoot) return;

    const width = renderer.domElement.clientWidth;
    const height = renderer.domElement.clientHeight;

    calloutEls.forEach(({ el, def }) => {
      const pt = new THREE.Vector3(def.pos[0], def.pos[1], def.pos[2]);
      if (def.group === "lid" && lidPivotGroup) {
        // Transform through lid pivot
        pt.sub(new THREE.Vector3(0, 6.0, 17.7));
        pt.applyAxisAngle(new THREE.Vector3(1, 0, 0), THREE.MathUtils.degToRad(180 - lidAngleDeg));
        pt.add(new THREE.Vector3(0, 156.0, 28.5 + explodeAmount * 1.4));
      } else {
        pt.z += explodeAmount * 0.5;
      }
      // Convert OpenSCAD local (X, Y, Z) through cadRoot transform
      pt.applyMatrix4(cadRoot.matrixWorld);
      pt.project(camera);

      if (pt.z > 1) {
        el.style.opacity = "0";
      } else {
        const x = (pt.x * 0.5 + 0.5) * width;
        const y = (-(pt.y * 0.5) + 0.5) * height;
        el.style.left = `${x}px`;
        el.style.top = `${y}px`;
        el.style.opacity = "1";
      }
    });
  }

  function onWindowResize() {
    const container = document.getElementById("webgl-container");
    if (!container || !renderer) return;
    const w = container.clientWidth;
    const h = container.clientHeight;
    if (w > 0 && h > 0) {
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
      renderer.setSize(w, h);
    }
  }

  function animate() {
    requestAnimationFrame(animate);
    if (autoSpinEnabled && cadRoot) {
      cadRoot.rotation.z += 0.0035;
    }
    if (controls) controls.update();
    if (renderer && scene && camera) {
      renderer.render(scene, camera);
      updateCalloutPinPositions();
    }
  }

  // --------------------------------------------------------------------------
  // 6. Markdown Documentation & OpenSCAD Explorer Renderer
  // --------------------------------------------------------------------------
  function preprocessGitHubMarkdown(md) {
    // Convert GitHub Alerts (> [!NOTE], > [!TIP], > [!IMPORTANT], > [!WARNING], > [!CAUTION])
    return md.replace(
      /(?:^|\n)>\s*\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]\s*\n((?:>.*(?:\n|$))+)/gi,
      (match, type, body) => {
        const kind = type.toLowerCase();
        const cleaned = body
          .split("\n")
          .map((line) => line.replace(/^>\s?/, ""))
          .join("\n")
          .trim();
        const icons = {
          note: "ℹ️ Note",
          tip: "💡 Engineering Tip",
          important: "⚡ Important Requirement",
          warning: "⚠️ Warning",
          caution: "🛑 Safety Caution",
        };
        const htmlInner = window.marked ? window.marked.parse(cleaned) : cleaned;
        return `\n<div class="gh-alert ${kind}"><div class="gh-alert-title">${icons[kind] || type}</div>${htmlInner}</div>\n`;
      }
    );
  }

  function buildScadExplorerHTML() {
    const scadMap = window.NS_CONV_SCAD || {};
    const names = Object.keys(scadMap);
    let html = `
      <h1>Parametric OpenSCAD Source Code & Binary STL Downloads</h1>
      <p>Every custom enclosure part is authored in 100% plain-text, parametric OpenSCAD with shared variables in <code>cad/config.scad</code>. Click any STL button below to preview it in the 3D Studio or download the print-ready mesh.</p>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Part Name</th>
              <th>3D Studio Action</th>
              <th>Direct Binary STL Download</th>
              <th>OpenSCAD Source</th>
            </tr>
          </thead>
          <tbody>
    `;
    const stlList = [
      ["base_bottom", "Lower Base Tub (306×162×24.5 mm)", "base_bottom.scad"],
      ["base_top_deck", "Top Keyboard & Trackball Deck (306×146×23.5 mm)", "base_top_deck.scad"],
      ["lid_rear", "Upper Lid Rear Shell (306×162×15.0 mm)", "lid_rear.scad"],
      ["lid_bezel", "Front Touchscreen Bezel (306×162×4.2 mm)", "lid_bezel.scad"],
      ["battery_retainer", "INIU Power Bank Retainer Strap", "battery_retainer.scad"],
      ["cable_clamp", "Hinge USB-C FPC Strain-Relief Clamp", "cable_clamp.scad"],
      ["test_fit_jig", "5-in-1 Stage-1 Verification Gauge Jig", "test_fit_jig.scad"],
    ];
    stlList.forEach(([id, desc, scadFile]) => {
      html += `
        <tr>
          <td><strong><code>${id}.stl</code></strong><br/><span style="font-size:11.5px">${desc}</span></td>
          <td><button class="hud-btn" onclick="window.nsConvSelectPart('${id}')">🔍 Inspect in 3D Viewer</button></td>
          <td><a class="hud-btn" href="models/${id}.stl" download="${id}.stl">⬇ Download ${id}.stl</a></td>
          <td><code>cad/${scadFile}</code></td>
        </tr>
      `;
    });
    html += `</tbody></table></div>`;

    names.forEach((fname) => {
      const code = scadMap[fname]
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
      html += `
        <h2><code>cad/${fname}</code></h2>
        <pre><code>${code}</code></pre>
      `;
    });
    return html;
  }

  async function renderGuide(key) {
    currentGuideKey = key;
    document.querySelectorAll(".nav-item").forEach((el) => {
      el.classList.toggle("active", el.dataset.key === key);
    });

    const meta = GUIDE_META.find((m) => m.key === key) || GUIDE_META[0];
    const bcEl = document.getElementById("doc-breadcrumb");
    if (bcEl) {
      bcEl.textContent = `${meta.badge}  //  ${meta.path}`;
    }

    const contentEl = document.getElementById("doc-content");
    if (!contentEl) return;

    if (key === "scad_explorer") {
      contentEl.innerHTML = buildScadExplorerHTML();
      document.querySelector(".docs-pane").scrollTop = 0;
      return;
    }

    const rawMd = (window.NS_CONV_GUIDES && window.NS_CONV_GUIDES[key]) || "# Guide Not Found";
    const processedMd = preprocessGitHubMarkdown(rawMd);
    const html = window.marked ? window.marked.parse(processedMd) : `<pre>${processedMd}</pre>`;
    contentEl.innerHTML = html;

    // Wrap tables in .table-wrap for clean horizontal scroll
    contentEl.querySelectorAll("table").forEach((tbl) => {
      if (!tbl.parentElement.classList.contains("table-wrap")) {
        const wrap = document.createElement("div");
        wrap.className = "table-wrap";
        tbl.parentNode.insertBefore(wrap, tbl);
        wrap.appendChild(tbl);
      }
    });

    // Fix relative image paths when viewing README.md (docs/renders/... -> renders/...)
    contentEl.querySelectorAll("img").forEach((img) => {
      const src = img.getAttribute("src") || "";
      if (src.startsWith("docs/renders/")) {
        img.setAttribute("src", src.replace("docs/renders/", "renders/"));
      } else if (src.startsWith("../docs/renders/")) {
        img.setAttribute("src", src.replace("../docs/renders/", "renders/"));
      }
    });

    // Intercept internal links to other phase guides or STL files
    contentEl.querySelectorAll("a").forEach((a) => {
      const href = a.getAttribute("href") || "";
      const routeMap = {
        "research.md": "phase1_research",
        "docs/research.md": "phase1_research",
        "bom.md": "phase2_bom",
        "docs/bom.md": "phase2_bom",
        "teardown.md": "phase3_teardown",
        "docs/teardown.md": "phase3_teardown",
        "wiring.md": "phase4_wiring",
        "docs/wiring.md": "phase4_wiring",
        "cad-overview.md": "phase5_cad",
        "docs/cad-overview.md": "phase5_cad",
        "print-spec.md": "phase6_print",
        "docs/print-spec.md": "phase6_print",
        "assembly.md": "phase7_assembly",
        "docs/assembly.md": "phase7_assembly",
        "software.md": "phase8_software",
        "docs/software.md": "phase8_software",
        "testing.md": "phase9_testing",
        "docs/testing.md": "phase9_testing",
        "risks.md": "phase10_risks",
        "docs/risks.md": "phase10_risks",
        "datasheets.md": "datasheets",
        "hardware/datasheets.md": "datasheets",
      };
      const cleanHref = href.replace(/^\.\.\//, "").split("#")[0];
      if (routeMap[cleanHref]) {
        a.addEventListener("click", (e) => {
          e.preventDefault();
          renderGuide(routeMap[cleanHref]);
        });
      } else if (cleanHref.endsWith(".stl")) {
        const partName = cleanHref.split("/").pop().replace(".stl", "");
        if (parsedGeometries[partName]) {
          a.addEventListener("click", (e) => {
            e.preventDefault();
            selectPartView(partName);
          });
        }
      }
    });

    // Render Mermaid diagrams inside ```mermaid code blocks
    const mermaidBlocks = contentEl.querySelectorAll("pre code.language-mermaid");
    if (mermaidBlocks.length > 0 && window.mermaid) {
      let idx = 0;
      for (const codeEl of mermaidBlocks) {
        const graphDef = codeEl.textContent;
        const pre = codeEl.parentElement;
        const card = document.createElement("div");
        card.className = "mermaid-card";
        const id = `mmd-${key}-${Date.now()}-${idx++}`;
        try {
          const { svg } = await window.mermaid.render(id, graphDef);
          card.innerHTML = svg;
          pre.replaceWith(card);
        } catch (err) {
          console.warn("Mermaid render fallback:", err);
        }
      }
    }

    document.querySelector(".docs-pane").scrollTop = 0;
  }

  // --------------------------------------------------------------------------
  // 7. Global Search & UI Event Wiring
  // --------------------------------------------------------------------------
  function initUIControls() {
    // Sidebar Guide List
    const navList = document.getElementById("guide-nav-list");
    GUIDE_META.forEach((item) => {
      const li = document.createElement("li");
      li.className = `nav-item ${item.key === currentGuideKey ? "active" : ""}`;
      li.dataset.key = item.key;
      li.innerHTML = `<span class="phase-pill">${item.badge}</span><span>${item.title}</span>`;
      li.addEventListener("click", () => renderGuide(item.key));
      navList.appendChild(li);
    });

    // Layout Mode Switcher (Split / 3D Studio Only / Docs Only)
    const workspace = document.getElementById("main-workspace");
    document.querySelectorAll(".layout-btn").forEach((btn) => {
      btn.addEventListener("click", () => {
        document.querySelectorAll(".layout-btn").forEach((b) => b.classList.remove("active"));
        btn.classList.add("active");
        workspace.classList.remove("mode-3d-only", "mode-docs-only");
        if (btn.dataset.mode === "3d") workspace.classList.add("mode-3d-only");
        if (btn.dataset.mode === "docs") workspace.classList.add("mode-docs-only");
        setTimeout(onWindowResize, 240);
      });
    });

    // SLA Color Swatches
    const swatchContainer = document.getElementById("swatch-container");
    SLA_COLOR_PRESETS.forEach((preset, idx) => {
      const sw = document.createElement("button");
      sw.className = `color-swatch ${idx === 0 ? "active" : ""}`;
      sw.style.background = preset.swatchCss;
      sw.title = `${preset.name} (${preset.price})`;
      sw.addEventListener("click", () => {
        document.querySelectorAll(".color-swatch").forEach((s) => s.classList.remove("active"));
        sw.classList.add("active");
        applyColorPreset(preset);
      });
      swatchContainer.appendChild(sw);
    });

    // Part Selector Chips
    document.querySelectorAll(".part-chip").forEach((chip) => {
      chip.addEventListener("click", () => selectPartView(chip.dataset.part));
    });

    // Lid Angle Slider & Presets
    const lidSlider = document.getElementById("lid-angle-slider");
    const lidVal = document.getElementById("lid-angle-val");
    lidSlider.addEventListener("input", () => {
      lidAngleDeg = parseFloat(lidSlider.value);
      lidVal.textContent = `${lidAngleDeg}°`;
      if (currentPartFilter !== "full") selectPartView("full");
      updateLidAndExplodeTransforms();
    });

    document.querySelectorAll("[data-lid-preset]").forEach((btn) => {
      btn.addEventListener("click", () => {
        lidAngleDeg = parseFloat(btn.dataset.lidPreset);
        lidSlider.value = lidAngleDeg;
        lidVal.textContent = `${lidAngleDeg}°`;
        if (currentPartFilter !== "full") selectPartView("full");
        updateLidAndExplodeTransforms();
      });
    });

    // Explode Slider
    const expSlider = document.getElementById("explode-slider");
    const expVal = document.getElementById("explode-val");
    expSlider.addEventListener("input", () => {
      explodeAmount = parseFloat(expSlider.value);
      expVal.textContent = `${explodeAmount}mm`;
      if (currentPartFilter !== "full") selectPartView("full");
      updateLidAndExplodeTransforms();
    });

    // HUD Toggle Buttons
    const btnWireframe = document.getElementById("btn-wireframe");
    btnWireframe.addEventListener("click", () => {
      wireframeEnabled = !wireframeEnabled;
      btnWireframe.classList.toggle("active", wireframeEnabled);
      allCadMeshes.forEach((m) => {
        m.material.wireframe = wireframeEnabled;
      });
    });

    const btnSpin = document.getElementById("btn-autospin");
    btnSpin.addEventListener("click", () => {
      autoSpinEnabled = !autoSpinEnabled;
      btnSpin.classList.toggle("active", autoSpinEnabled);
    });

    const btnCallouts = document.getElementById("btn-callouts");
    btnCallouts.addEventListener("click", () => {
      calloutsEnabled = !calloutsEnabled;
      btnCallouts.classList.toggle("active", calloutsEnabled);
    });

    const btnScreenOs = document.getElementById("btn-screen-os");
    const screenNames = ["Chimera 6.18", "Hekate Nyx", "Horizon OS"];
    btnScreenOs.addEventListener("click", () => {
      screenModeIndex = (screenModeIndex + 1) % 3;
      drawSwitchScreenContent(screenModeIndex);
      btnScreenOs.textContent = `🖥 LCD: ${screenNames[screenModeIndex]}`;
    });

    const btnResetCam = document.getElementById("btn-reset-cam");
    btnResetCam.addEventListener("click", () => {
      if (cadRoot) cadRoot.rotation.z = 0;
      camera.position.set(275, 225, 345);
      controls.target.set(0, 22, 0);
      controls.update();
    });

    // Instant Search across all 10 Guides
    const searchInput = document.getElementById("global-search-input");
    const searchDropdown = document.getElementById("search-results-dropdown");
    searchInput.addEventListener("input", () => {
      const q = searchInput.value.trim().toLowerCase();
      if (q.length < 2) {
        searchDropdown.classList.remove("open");
        return;
      }
      const hits = [];
      GUIDE_META.forEach((m) => {
        const text = (window.NS_CONV_GUIDES && window.NS_CONV_GUIDES[m.key]) || "";
        const idx = text.toLowerCase().indexOf(q);
        if (idx !== -1) {
          const start = Math.max(0, idx - 45);
          const snippet = text
            .slice(start, idx + 85)
            .replace(/[#*`|>\n]/g, " ")
            .trim();
          hits.push({ meta: m, snippet: `...${snippet}...` });
        }
      });

      if (hits.length === 0) {
        searchDropdown.innerHTML = `<div class="search-hit"><div class="search-hit-snippet">No matches for "${q}"</div></div>`;
      } else {
        searchDropdown.innerHTML = hits
          .map(
            (h) => `
            <div class="search-hit" data-key="${h.meta.key}">
              <div class="search-hit-title">[${h.meta.badge}] ${h.meta.title}</div>
              <div class="search-hit-snippet">${h.snippet}</div>
            </div>`
          )
          .join("");
        searchDropdown.querySelectorAll(".search-hit").forEach((el) => {
          el.addEventListener("click", () => {
            renderGuide(el.dataset.key);
            searchDropdown.classList.remove("open");
            searchInput.value = "";
          });
        });
      }
      searchDropdown.classList.add("open");
    });

    document.addEventListener("click", (e) => {
      if (!searchInput.contains(e.target) && !searchDropdown.contains(e.target)) {
        searchDropdown.classList.remove("open");
      }
    });
  }

  // Expose helper for inline buttons
  window.nsConvSelectPart = function (partId) {
    selectPartView(partId);
  };

  // Boot Application
  window.addEventListener("DOMContentLoaded", () => {
    if (window.mermaid) {
      window.mermaid.initialize({ startOnLoad: false, theme: "dark" });
    }
    initUIControls();
    renderGuide("overview");
    init3DViewer();
  });
})();
