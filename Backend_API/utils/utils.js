

exports.calculateTokenExpirationTime = (hours) => {
    const newDate = new Date();
    newDate.setHours(newDate.getHours() + hours);
    return newDate;
}


exports.UpdateHistoryObj = (CollectionName, DocumentID, Updates, Functionality) => {
    this.CollectionName = CollectionName;
    this.DocumentID = DocumentID;
    this.Updates = Updates;
    this.Functionality = Functionality;
}