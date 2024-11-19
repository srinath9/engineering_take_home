// App.js or wherever your routes are defined
import React from "react";
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import BuildingList from "./BuildingList";
import NewBuilding from "./NewBuilding";
import EditBuilding from "./EditBuilding";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<BuildingList />} />
        <Route path="/clients/:clientId/buildings/new" element={<NewBuilding />} />
        <Route path="/buildings/:buildingId/edit" element={<EditBuilding />} />
      </Routes>
    </Router>
  );
};

export default App;

