import React, { useEffect, useState } from "react";
import axios from "axios";
import { useLocation, useNavigate } from "react-router-dom";
import BuildingItem from "./BuildingItem";
import ClientDropDown from "./ClientDropDown";

const BuildingList = () => {
  const [buildings, setBuildings] = useState([]);
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);

  const navigate = useNavigate();
  const location = useLocation();

  const fetchBuildings = async (page) => {
    try {
      const response = await axios.get(`/api/v1/buildings?page=${currentPage}`);
      setBuildings(response.data.buildings);
      setTotalPages(response.data.total_pages);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchClients = async () => {
    try {
      const response = await axios.get(`/api/v1/clients`);
      setClients(response.data);
    } catch (err) {
      setError(err.message);
    }
  };

  useEffect(() => {
    fetchClients();
  }, []);

  useEffect(() => {
    window.scrollTo(0, 0);
    fetchBuildings(currentPage);
  }, [currentPage]);

  useEffect(() => {
    if (location.state?.successMessage) {
      setSuccessMessage(location.state.successMessage);
      setTimeout(() => {
        setSuccessMessage("");
      }, 5000);
    }
  }, [location.state?.successMessage]);

  const handleNextPage = () => {
    if (currentPage < totalPages) {
      setCurrentPage(currentPage + 1);
    }
  };

  const handlePreviousPage = () => {
    if (currentPage > 1) {
      setCurrentPage(currentPage - 1);
    }
  };

  const handleCreateBuilding = (clientId) => {
    navigate(`/clients/${clientId}/buildings/new`);
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  const headerStyle = {
    padding: "0 0 0 16px",
  };

  const createButtonStyle = {
    backgroundColor: "#3498db",
    color: "white",
    border: "none",
    borderRadius: "4px",
    padding: "8px 12px",
    cursor: "pointer",
    margin: "0 0 0 16px",
    transition: "background-color 0.2s",
  };

  const successBannerStyle = {
    backgroundColor: "#d4edda",
    color: "#155724",
    padding: "10px",
    borderRadius: "5px",
    marginBottom: "16px",
  };

  return (
    <div>
      {successMessage && <div style={successBannerStyle}>{successMessage}</div>}
      <h1 style={headerStyle}>Buildings</h1>
      <ClientDropDown
        clients={clients}
        handleCreateBuilding={handleCreateBuilding}
      />
      {buildings.map((building) => (
        <BuildingItem
          key={building.id}
          clientId={building.client.id}
          building={building}
        />
      ))}
      <div style={{ padding: "0 0 0 16px" }} className="pagination">
        <button onClick={handlePreviousPage} disabled={currentPage === 1}>
          Previous
        </button>
        <button onClick={handleNextPage} disabled={currentPage === totalPages}>
          Next
        </button>
      </div>
    </div>
  );
};

export default BuildingList;
