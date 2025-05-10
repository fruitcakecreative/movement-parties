import ReactDOM from "react-dom";

const ModalLayout = ({ isOpen, onClose, className = "", header, children, parent, innerStyle = {}, topRowStyle = {} }) => {

  if (!isOpen) return null;

   return ReactDOM.createPortal(
    <div className={`program-modal ${className} ${parent}`}>
      <div className="modal-outer">
        <div className="modal-inner" style={innerStyle}>
          <div className="top-row" style={topRowStyle}>
            {header}
            <button className="exit-modal" onClick={onClose}>
              <i className="fa-solid fa-xmark" style={{ "color": topRowStyle.color }}></i>
            </button>
          </div>
          <div className="main-content" style={{ "--scroll-thumb-color": innerStyle.scrollBarColor }}>
            {children}
          </div>
        </div>
      </div>
    </div>,
    document.getElementById("modal-root")
  );
};

export default ModalLayout;
