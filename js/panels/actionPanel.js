// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.ActionPanel = (function(_super) {

    __extends(ActionPanel, _super);

    function ActionPanel(panelPosition, panelSize, state) {
      this.panelPosition = panelPosition;
      this.panelSize = panelSize;
      this.state = state;
      this.buttonSize;
      this.selectedUnit;
      ActionPanel.__super__.constructor.call(this, this.panelPosition.x, this.panelPosition.y, this.panelSize.w, this.panelSize.h);
      this.init();
      this.updatePanel();
    }

    ActionPanel.prototype.init = function() {
      this.buttonSize = {
        w: 30,
        h: 30
      };
      this.attackButton = new Coffee2D.Image('img/icons/attackIcon.png');
      this.attackButton.setSize(this.buttonSize.w, this.buttonSize.h);
      this.attackButton.setPosition(0, 0);
      this.attackButton.addListener('click', (function(evt) {
        var newEvt;
        if (this.state.mode !== 'unitMoving') {
          newEvt = {
            type: 'selectAttackTarget',
            from: this.selectedUnit
          };
          return this.dispatchEvent(newEvt);
        }
      }).bind(this));
      return this.addChild(this.attackButton);
    };

    ActionPanel.prototype.updatePanel = function() {
      if ((Common.selected instanceof Unit) && (Common.selected.belongsTo === Common.player)) {
        return this.show();
      } else {
        return this.hide();
      }
    };

    return ActionPanel;

  })(Component);

}).call(this);
