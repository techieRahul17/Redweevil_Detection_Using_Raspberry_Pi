from inference import get_model
import time
import cv2 as cv
import warnings
from dotenv import load_dotenv
import os



class CheckRedweevil():
    def __init__(self):
        load_dotenv()
        ROBOFLOW_API = os.getenv('ROBOFLOW_API')

        self.model = get_model(model_id='redweevil/1',api_key=ROBOFLOW_API)

    def check(self,images):

        results = self.model.infer(images,confidence=0.8)

        return results

def webcam(model):

    cam = cv.VideoCapture(1)

    prev_time = 0

    while True:
        ret, frame = cam.read()

        if not ret:
            print("Failed to capture frame")
            break

        curr_time = time.time()
        fps = 1 / (curr_time - prev_time) if prev_time > 0 else 0
        prev_time = curr_time

        # fps *= 1.5

        results = model.check(frame)

        for pred in results[0].predictions:
            x, y, w, h = pred.x, pred.y, pred.width, pred.height
            class_name = pred.class_name
            conf = pred.confidence

            x1 = int(x - w/2)
            y1 = int(y - h/2)
            x2 = int(x + w/2)
            y2 = int(y + h/2)

            cv.rectangle(frame, (x1, y1), (x2, y2), (0,255,0), 5)
            cv.putText(frame, f"Redweevil {class_name} {conf:.2f}",
                           (x1, y1-10), cv.FONT_HERSHEY_SIMPLEX,
                           2, (0,255,0), 5)

            cv.putText(frame, f"FPS: {fps:.2f}",
                               (10, 30), cv.FONT_HERSHEY_SIMPLEX,
                               1, (0, 0, 255), 2)

            cv.imshow("Webcam", frame)

        cv.imshow('Webcam', frame)
        if cv.waitKey(1) & 0xFF == ord('q'):
            break
    cam.release()
    cv.destroyAllWindows()


def main():
    start_time = time.time()

    model = CheckRedweevil()

    webcam(model)

    print("Hello from backend!")

    end_time = time.time()
    print(f"Execution time: {end_time - start_time} seconds")


if __name__ == "__main__":
    main()
