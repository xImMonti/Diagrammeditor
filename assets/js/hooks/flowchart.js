
import Drawflow from 'drawflow';

const Flowchart = {
  mounted() {
    this.mobile_item_select = '';
    this.item_selec = '';
    this.mobile_last_move = null;

    const container = this.el.querySelector(".flowchart__wrapper");
    this.editor = new Drawflow(container);

    this.editor.curvature = 0;
    this.editor.reroute_curvature_start_end = 0;
    this.editor.reroute_curvature = 0;

    this.editor.createCurvature = function (start_pos_x, start_pos_y, end_pos_x, end_pos_y, curvature_value) {
      var center_x = ((end_pos_x - start_pos_x) / 2) + start_pos_x;
      return ' M ' + start_pos_x + ' ' + start_pos_y + ' L ' + center_x + ' ' + start_pos_y + ' L ' + center_x + ' ' + end_pos_y + ' L ' + end_pos_x + ' ' + end_pos_y;
    }
    this.editor.reroute = true;
    this.editor.start();

    this.pushEvent("get-flowchart-data", {}, (reply, ref) =>
      this.start_import(reply)
    );
  },
  start_import(flowchartData) {
    if (flowchartData) {
      this.editor.import(flowchartData)
    }

    var textNodes = document.getElementsByClassName('flowchart__element-uml-text');
    for (var i = 0; i < textNodes.length; i++) {
      nodeId = textNodes[i].id.split("-")[1];
      this.add_uml_text_event_listener(nodeId);
    }

    var elements = document.getElementsByClassName('drag-drawflow');
    for (var i = 0; i < elements.length; i++) {
      elements[i].addEventListener('touchend', event => this.drop(event), false);
      elements[i].addEventListener('touchmove', event => this.positionMobile(event), false);
      elements[i].addEventListener('touchstart', event => this.drag(event), false);
      elements[i].addEventListener('dragstart', event => this.drag(event), false);
      elements[i].addEventListener('dragend', event => this.drop(event), false);
    }

    this.el.addEventListener('click', (e) => {
      if (e.target.classList.contains('flowchart__element-process__button') || e.target.classList.contains('flowchart__element-process__button-icon')) {
        nodeId = e.target.closest(".drawflow-node").getAttribute('id').split("-")[1];
        this.add_process_event_listener(nodeId);
      }
    });

    document.querySelector("#process-save-all").addEventListener("click", () => {
      var exportdata = this.editor.export();

      this.pushEvent('save-process-all', {
        exportdata: exportdata
      });
    });

    document.querySelector("#process-save-all-and-close").addEventListener("click", () => {
      var exportdata = this.editor.export();

      this.pushEvent('save-process-all-and-close', {
        exportdata: exportdata
      });
    });

    document.querySelector("process-reset").addEventListener("click", () => {
      // Browser Prompt to confirm reset
      if (confirm("Soll die Zeichenfläche wirklich zurückgesetzt werden?")) {
        this.editor.clear();
      }
    });
  },
  drag(ev) {
    if (ev.type === "touchstart") {
      this.mobile_item_select = ev.target.closest(".drag-drawflow").getAttribute('data-node');
      this.mobile_item_select = ev.target.closest(".drag-drawflow").getAttribute('data-node');
    } else {
      this.item_selec = ev.target.getAttribute('data-node');
    }
  },
  drop(ev) {
    if (ev.type === "touchend") {
      let parentdrawflow = document.elementFromPoint(this.mobile_last_move.touches[0].clientX, this.mobile_last_move.touches[0].clientY).closest("#drawflow");
      if (parentdrawflow != null) {
        addNodeToDrawFlow(this.mobile_item_select, this.mobile_last_move.touches[0].clientX, this.mobile_last_move.touches[0].clientY);
      }
      this.mobile_item_select = '';
    } else {
      ev.preventDefault();
      let data = this.item_selec;
      this.addNodeToDrawFlow(data, ev.clientX, ev.clientY);
    }
    this.item_selec = '';

  },
  positionMobile(ev) {
    this.mobile_last_move = ev;
  },
  addNodeToDrawFlow(name, pos_x, pos_y) {
    if (this.editor.editor_mode === 'fixed') {
      return false;
    }
    pos_x = pos_x * (this.editor.precanvas.clientWidth / (this.editor.precanvas.clientWidth * this.editor.zoom)) - (this.editor.precanvas.getBoundingClientRect().x * (this.editor.precanvas.clientWidth / (this.editor.precanvas.clientWidth * this.editor.zoom)));
    pos_y = pos_y * (this.editor.precanvas.clientHeight / (this.editor.precanvas.clientHeight * this.editor.zoom)) - (this.editor.precanvas.getBoundingClientRect().y * (this.editor.precanvas.clientHeight / (this.editor.precanvas.clientHeight * this.editor.zoom)));

    let nodeTemplate = this.el.querySelector("#" + name);

    nodeId = this.editor.addNode(
      name,
      nodeTemplate.getAttribute("data-inputs"),
      nodeTemplate.getAttribute("data-outputs"),
      pos_x,
      pos_y,
      'flowchart__element flowchart__element-' + name,
      { "description": "", "name": "" },
      nodeTemplate.innerHTML);

    if (name == "process") {
      this.add_process_event_listener(nodeId);
    }
  },
  add_process_event_listener(nodeId) {

    node = this.el.querySelector("#node-" + nodeId);

    let processButton = node.querySelector(".flowchart__element-process__button");
    processButton.addEventListener("click", (e) => {
      this.el.querySelector("#process__name").value = e.target.closest(".drawflow-node").querySelector(".flowchart__element-process__header").innerHTML;
      this.el.querySelector("#process__description").value = e.target.closest(".drawflow-node").querySelector(".flowchart__element-process__description").innerHTML;
    });

    let process__save = this.el.querySelector(".process__save");
    process__save.addEventListener("click", () => {
      node.querySelector(".flowchart__element-process__header").innerHTML = this.el.querySelector("#process__name").value;
      node.querySelector(".flowchart__element-process__description").innerHTML = this.el.querySelector("#process__description").value;
      this.editor.updateNodeDataFromId(nodeId, {
        name: this.el.querySelector("#process__name").value,
        description: this.el.querySelector("#process__description").value,
      });
    });
  }
}

export { Flowchart };
