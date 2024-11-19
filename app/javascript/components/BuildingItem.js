import React from "react";
import { useNavigate } from "react-router-dom";

const BuildingItem = ({ clientId, building }) => {
  const navigate = useNavigate();

  const handleEdit = () => {
    navigate(`/buildings/${building.id}/edit`, { state: { building } });
  };


  const cardStyle = {
    backgroundColor: '#fff',
    borderRadius: '8px',
    boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
    padding: '16px',
    margin: '16px',
    transition: 'transform 0.2s',
  };

  const AddressDisplay = ({ building }) => {

    const { address  } = building;
  
    return (
  
      <div>
        <h3>{`${address.address1}`}</h3>
        <h4>{`${building.client.name}`}</h4>
        <address>
          {address.address2 && <div>{address.address2}</div>}
          <div>{`${address.city}, ${address.state}`}</div>
          <div>{`${address.country} - ${address.postal_code}`}</div>
          <br/>
        </address>
      </div>
  
    );
  
  };

  return (
    <div style={cardStyle}>
      <AddressDisplay  building={building}/>
      <button onClick={() => handleEdit()}>
        Edit
      </button>
    </div>
  );
};

export default BuildingItem;
