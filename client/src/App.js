import { Route, Routes, BrowserRouter } from "react-router-dom";
import Home from "./pages/Home";
import MovementValidation from "./pages/MovementValidation";
import StockTransaction from "./pages/StockTransaction";

import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css'

function App() {
  return (
    <div className="App d-flex justify-content-center m-5 p-5">
      <BrowserRouter>
        <Routes>
          <Route index element={<Home />} />
          <Route path="/movement/validation" exact element={<MovementValidation />} />
          <Route path="/stock/transaction" exact element={<StockTransaction />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
