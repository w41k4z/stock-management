import React, { useEffect, useState } from 'react'
import Axios from 'axios'

const Home = () => {
  const [stockState, setStockState] = useState([]);
  const [fromDate, setFromDate] = useState();
  const [toDate, setToDate] = useState();
  const [storePattern, setStorePattern] = useState('');
  const [articlePattern, setArticlePattern] = useState('');
  useEffect(() => {
    if (fromDate && toDate) {
      getStockState();
    }
  }, [fromDate, toDate])

  const getStockState = async () => {
    const body = {
      date1: fromDate,
      date2: toDate,
      store: storePattern,
      article: articlePattern
    }
    await Axios.get('http://localhost:8080/stockState', body).then((response) => {
      setStockState(response.data)
    }).catch((error) => {
      alert(error)
    })
  }

  return (
    <div className='w-100'>
      <div className='d-flex justify-content-between mb-3'>
        <div className='d-flex align-items-center'>
          <label htmlFor='fromDate'>From: </label>
          <input type='date' className='ms-2 form-control' onChange={
            (e) => {
              setFromDate(e.target.value)
            }
          } id='fromDate' />
        </div>
        <div className='d-flex align-items-center'>
          <label htmlFor='toDate'>To: </label>
          <input type='date' className='ms-2 form-control' onChange={
            (e) => {
              setToDate(e.target.value)
            }
          } id='toDate' />
        </div>
      </div>
      <div className='d-flex justify-content-between mb-3'>
        <div className='d-flex align-items-center'>
          <label htmlFor='storePattern'>Store: </label>
          <input type='text' className='ms-2 form-control' onChange={
            (e) => {
              setStorePattern(e.target.value)
            }
          } id='storePattern' />
        </div>
        <div className='d-flex align-items-center'>
          <label htmlFor='articlPattern'>Article: </label>
          <input type='text' className='ms-2 form-control' onChange={
            (e) => {
              setArticlePattern(e.target.value)
            }
          } id='articlPattern' />
        </div>
      </div>
      <div className='table-responsive'>
        <table className="table table-striped">
            <thead className="px-2 table-bordered table-dark">
                <tr className='text-white'>
                  <th scope="col">Store</th>
                  <th scope="col">Article</th>
                  <th scope="col">Initial stock</th>
                  <th scope="col">Remaining stock</th>
                  <th scope="col">AVG UP</th>
                  <th scope="col">Total price</th>
                </tr>
            </thead>
          <tbody className="px-2">
            {stockState.map((item, index) => {
              return (
                <tr key={index}>
                  <td>{item.storeCode}</td>
                  <td>{item.articleCode}</td>
                  <td>{item.initialStock}</td>
                  <td>{item.remainingStock}</td>
                  <td>{item.averageUnitPrice}</td>
                  <td>{item.totalPrice}</td>
                </tr>
              )
            })}
          </tbody>
          <tfoot>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td className='text-success'>TOTAL: </td>
                <td>X</td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  )
}

export default Home