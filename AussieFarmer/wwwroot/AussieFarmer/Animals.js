class Animals {

    ////////////////
    //Initializers//
    ////////////////
    constructor() {
        this.Heads = 0;
        this.Cost = 0;
        this.CostFormularM = 0;
        this.CostFormularA = 0;
        this.Value = 0;
        this.ValuePerHead = 0;
        this.ItemDisplayDelay = 0;
        this.CurrentItems = 0;
        this.Name = "";
        this.ItemName = "";
        this.ItemDispayFirst = true;
        this.MoneyToTake = 0;
    }

    Init(costFormularM, costFormularA, valuePerHead, itemDisplayDelay, name, itemName) {
        this.CostFormularM = costFormularM;
        this.CostFormularA = costFormularA;
        this.ValuePerHead = valuePerHead;
        this.ItemDisplayDelay = itemDisplayDelay * 60;
        this.Cost = costFormularA;
        this.Name = name;
        this.ItemName = itemName;
    }

    ////////////////////
    //Public Functions//
    ////////////////////

    WhenPressed() {
        //check to see if item is ready to collect
        if (!this.ItemDispayFirst) {
            this.CollectItem();
        }
    }

    AddHead(Money) {
        if (Money >= this.Cost) {
            this.Heads++;
            this.MoneyToTake -= this.Cost;
            this.CalculateNewCost();
            this.CalculateNewValue();
        }
    }

    Load(num) {
        this.Heads = num;
        this.CalculateNewCost();
        this.CalculateNewValue();
    }

    Update() {
        document.getElementById(`${this.Name}Info`).innerHTML = `
            ${this.Name}: ${this.Heads}
            </br>
            Cost: $${this.Cost}
            </br>
            Value: $${Math.floor(this.Value / this.ItemDisplayDelay * 60)}/sec
            `;
        this.CheckItem();
        this.tempcost = this.MoneyToTake;
        this.MoneyToTake = 0;
        return this.tempcost;
    }

    /////////////////////
    //Private Functions//
    /////////////////////

    CollectItem() {
        this.ItemDispayFirst = true;
        this.CurrentItems = 0;
        document.getElementById(`${this.Name}ItemDiv`).innerHTML = "";
        this.MoneyToTake += this.Value;
    }

    CalculateNewCost() {
        this.Cost = this.CostFormularM * this.Heads + this.CostFormularA;
    }

    CalculateNewValue() {
        this.Value = this.Heads * this.ValuePerHead;
    }

    CheckItem() {
        if (this.CurrentItems >= this.ItemDisplayDelay) {
            this.displayAnimalItem();
        }
        this.CurrentItems++;
    }

    displayAnimalItem() {
        if (this.ItemDispayFirst && this.Heads != 0) {
            document.getElementById(`${this.Name}ItemDiv`).innerHTML = `
                <img id="${this.Name}Item" class="ItemImage"
                    onclick="a_game.${this.Name}.WhenPressed()"
                    src="AussieFarmer/Images/${this.ItemName}.png"/>
            `;
            this.ItemDispayFirst = false;
        }
    }
};
