import React, { useState } from "react";

const ClientDropDown = ({ clients, handleCreateBuilding }) => {
  const [selectedClientId, setSelectedClientId] = useState("");

  const handleChange = (e) => {
    setSelectedClientId(e.target.value);
  };

  return (
    <div style={{ padding: "16px" }}>
      <select
        value={selectedClientId}
        onChange={handleChange}
        style={{ padding: "8px", marginRight: "12px" }}
      >
        <option value="" disabled>
          Select a Client
        </option>
        {clients.map((client) => (
          <option key={client.id} value={client.id}>
            {client.name}
          </option>
        ))}
      </select>

      <button
        style={{
          backgroundColor: "#2980b9",
          color: "white",
          padding: "8px 16px",
          border: "none",
          cursor: "pointer",
        }}
        onClick={() => {
          if (selectedClientId) {
            handleCreateBuilding(selectedClientId);
          } else {
            alert("Please select a client.");
          }
        }}
      >
        Create New Building
      </button>
    </div>
  );
};

export default ClientDropDown;
