defmodule Lab1W4.CarSensors do
  def startCarSensors() do
    pid = spawn(fn -> loopMainSensor(7, %{}) end)
    send(pid, :start)

    pid
  end

  def loopMainSensor(deadSensors, pidMap) do
    receive do
      :start ->
        pidCabin = startCabinSensor(self())
        IO.puts("Cabin Sensor pid: #{inspect(pidCabin)}")
        Process.monitor(pidCabin)
        pidMap = Map.put(pidMap, pidCabin, &Lab1W4.CarSensors.startCabinSensor/1)

        pidMotor = startMotorSensor(self())
        IO.puts("Motor Sensor pid: #{inspect(pidMotor)}")
        Process.monitor(pidMotor)
        pidMap = Map.put(pidMap, pidMotor, &startMotorSensor/1)

        pidChassis = startChassisSensor(self())
        IO.puts("Chassis Sensor pid: #{inspect(pidChassis)}")
        Process.monitor(pidChassis)
        pidMap = Map.put(pidMap, pidChassis, &startChassisSensor/1)

        startWheelSupervisor(self())

        loopMainSensor(deadSensors, pidMap)

      {:DOWN, _ref, :process, monitoredSensorPid, _reason} ->
        deadSensors = deadSensors + 1

        if deadSensors > 1 do
          IO.puts("AIRBAGS DEPLOYED.")
        end

        IO.puts("Main Supervisor: Crash detected. Restarting...")
        newPid = pidMap[monitoredSensorPid].(self())
        Process.monitor(newPid)
        IO.puts("#{inspect(monitoredSensorPid)} died. New pid: #{inspect(newPid)}")
        pidMap = Map.put(pidMap, newPid, pidMap[monitoredSensorPid])
        pidMap = Map.delete(pidMap, monitoredSensorPid)
        loopMainSensor(deadSensors, pidMap)

      :alive ->
        loopMainSensor(deadSensors - 1, pidMap)

      :dead ->
        deadSensors = deadSensors + 1

        if deadSensors > 1 do
          IO.puts("AIRBAGS DEPLOYED.")
        end

        loopMainSensor(deadSensors, pidMap)
    end
  end

  def startCabinSensor(pid) do
    spawn(fn -> initCabinSensor(pid) end)
  end

  defp initCabinSensor(pid) do
    IO.puts("Cabin Sensor started and measuring.")
    send(pid, :alive)
    loopCabinSensor()
  end

  defp loopCabinSensor() do
    Process.sleep(2000)
    loopCabinSensor()
  end

  def startMotorSensor(pid) do
    spawn(fn -> initMotorSensor(pid) end)
  end

  defp initMotorSensor(pid) do
    IO.puts("Motor Sensor started and measuring.")
    send(pid, :alive)
    loopMotorSensor()
  end

  defp loopMotorSensor() do
    Process.sleep(2000)
    loopMotorSensor()
  end

  def startChassisSensor(pid) do
    spawn(fn -> initChassisSensor(pid) end)
  end

  defp initChassisSensor(pid) do
    IO.puts("Chassis Sensor started and measuring.")
    send(pid, :alive)
    loopChassisSensor()
  end

  defp loopChassisSensor() do
    Process.sleep(2000)
    loopChassisSensor()
  end

  def startWheelSupervisor(pidMain) do
    pid = spawn(fn -> loopWheel(pidMain, %{}) end)
    send(pid, :start)

    pid
  end

  defp loopWheel(pidMain, pidMap) do
    receive do
      {:DOWN, _ref, :process, monitoredSensorPid, _reason} ->
        send(pidMain, :dead)

        IO.puts("Wheel Supervisor: Crash detected. Restarting...")
        newPid = pidMap[monitoredSensorPid].(self())
        Process.monitor(newPid)
        IO.puts("#{inspect(monitoredSensorPid)} died. New pid: #{inspect(newPid)}")
        pidMap = Map.put(pidMap, newPid, pidMap[monitoredSensorPid])
        pidMap = Map.delete(pidMap, monitoredSensorPid)
        loopWheel(pidMain, pidMap)

      :alive ->
        send(pidMain, :alive)
        loopWheel(pidMain, pidMap)

      :start ->
        pidWheel1 = startWheelSensor(self())
        IO.puts("Wheel1 Sensor pid: #{inspect(pidWheel1)}")
        Process.monitor(pidWheel1)
        pidMap = Map.put(pidMap, pidWheel1, &Lab1W4.CarSensors.startWheelSensor/1)

        pidWheel2 = startWheelSensor(self())
        IO.puts("Wheel2 Sensor pid: #{inspect(pidWheel2)}")
        Process.monitor(pidWheel2)
        pidMap = Map.put(pidMap, pidWheel2, &Lab1W4.CarSensors.startWheelSensor/1)

        pidWheel3 = startWheelSensor(self())
        IO.puts("Wheel3 Sensor pid: #{inspect(pidWheel3)}")
        Process.monitor(pidWheel3)
        pidMap = Map.put(pidMap, pidWheel3, &Lab1W4.CarSensors.startWheelSensor/1)

        pidWheel4 = startWheelSensor(self())
        IO.puts("Wheel4 Sensor pid: #{inspect(pidWheel4)}")
        Process.monitor(pidWheel4)
        pidMap = Map.put(pidMap, pidWheel4, &Lab1W4.CarSensors.startWheelSensor/1)

        loopWheel(pidMain, pidMap)
    end
  end

  def startWheelSensor(pid) do
    spawn(fn -> initWheelSensor(pid) end)
  end

  defp initWheelSensor(pid) do
    IO.puts("Wheel Sensor started and measuring.")
    send(pid, :alive)
    loopWheelSensor()
  end

  defp loopWheelSensor() do
    Process.sleep(2000)
    loopWheelSensor()
  end
end
