# ============================================================================
# ns-conv: Parametric OpenSCAD Build System (STL, 3MF & PNG Preview Exporter)
# Usage:
#   make -C cad all        # Exports all print-ready STLs, 3MFs, and PNG renders
#   make -C cad stl        # Exports print-ready STLs to cad/stl/
#   make -C cad 3mf        # Exports print-ready 3MFs to cad/3mf/
#   make -C cad renders    # Renders PNG assembly & part previews to docs/renders/
# ============================================================================

OPENSCAD ?= $(shell command -v openscad 2>/dev/null || echo "$(HOME)/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD")
SCAD_FLAGS ?= --backend=Manifold --hardwarnings

PARTS = \
	base_bottom \
	base_top_deck \
	lid_rear \
	lid_bezel \
	battery_retainer \
	cable_clamp \
	test_fit_jig

STL_DIR = stl
TMF_DIR = 3mf
RENDER_DIR = ../docs/renders

STLS = $(patsubst %,$(STL_DIR)/%.stl,$(PARTS))
TMFS = $(patsubst %,$(TMF_DIR)/%.3mf,$(PARTS))

.PHONY: all stls 3mfs renders clean

all: stls 3mfs renders

$(STL_DIR)/%.stl: %.scad config.scad
	@mkdir -p $(STL_DIR)
	@echo "==> Exporting STL: $@"
	"$(OPENSCAD)" $(SCAD_FLAGS) -o "$@" "$<"

$(TMF_DIR)/%.3mf: %.scad config.scad
	@mkdir -p $(TMF_DIR)
	@echo "==> Exporting 3MF: $@"
	"$(OPENSCAD)" $(SCAD_FLAGS) -o "$@" "$<"

stls: $(STLS)

3mfs: $(TMFS)

renders:
	@mkdir -p $(RENDER_DIR)
	@echo "==> Rendering Assembly Open (112 deg) Isometric View..."
	"$(OPENSCAD)" $(SCAD_FLAGS) --imgsize=1600,1200 --projection=p --autocenter --viewall \
		--camera=0,60,80,58,0,35,620 --colorscheme="Tomorrow Night" \
		-D "lid_open_angle=112" -D "exploded_z=0" \
		-o "$(RENDER_DIR)/assembly_open_iso.png" assembly_preview.scad
	@echo "==> Rendering Assembly Exploded View..."
	"$(OPENSCAD)" $(SCAD_FLAGS) --imgsize=1600,1200 --projection=p --autocenter --viewall \
		--camera=0,60,95,60,0,38,720 --colorscheme="Tomorrow Night" \
		-D "lid_open_angle=112" -D "exploded_z=22" \
		-o "$(RENDER_DIR)/assembly_exploded.png" assembly_preview.scad
	@echo "==> Rendering Assembly Closed Clamshell View..."
	"$(OPENSCAD)" $(SCAD_FLAGS) --imgsize=1600,1200 --projection=p --autocenter --viewall \
		--camera=0,70,25,62,0,35,540 --colorscheme="Tomorrow Night" \
		-D "lid_open_angle=0" -D "exploded_z=0" \
		-o "$(RENDER_DIR)/assembly_closed.png" assembly_preview.scad
	@echo "==> Rendering Individual Part Previews..."
	@for p in $(PARTS); do \
		"$(OPENSCAD)" $(SCAD_FLAGS) --render --imgsize=1200,900 --projection=p --autocenter --viewall \
			--colorscheme="Tomorrow Night" -o "$(RENDER_DIR)/$$p.png" "$$p.scad"; \
	done

clean:
	rm -rf $(STL_DIR) $(TMF_DIR) $(RENDER_DIR)
