//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2012.12.12 at 01:56:52 PM MEZ 
//


package de.tudresden.inf.rn.mobilis.gwtemulationserver.server.script;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElementRef;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for structureType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="structureType">
 *   &lt;complexContent>
 *     &lt;extension base="{http://mobilis.inf.tu-dresden.de/XMLEmulationScript}commandType">
 *       &lt;sequence>
 *         &lt;element ref="{http://mobilis.inf.tu-dresden.de/XMLEmulationScript}command" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "structureType", propOrder = {
    "command"
})
@XmlSeeAlso({
    ForType.class,
    BlockType.class
})
public class StructureType
    extends CommandType
{

    @XmlElementRef(name = "command", namespace = "http://mobilis.inf.tu-dresden.de/XMLEmulationScript", type = JAXBElement.class)
    protected List<JAXBElement<? extends CommandType>> command;

    /**
     * Gets the value of the command property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the command property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getCommand().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link JAXBElement }{@code <}{@link InstanceGroupType }{@code >}
     * {@link JAXBElement }{@code <}{@link AtomicCommandType }{@code >}
     * {@link JAXBElement }{@code <}{@link AppCommandType }{@code >}
     * {@link JAXBElement }{@code <}{@link WaitType }{@code >}
     * {@link JAXBElement }{@code <}{@link StopType }{@code >}
     * {@link JAXBElement }{@code <}{@link BlockType }{@code >}
     * {@link JAXBElement }{@code <}{@link StartType }{@code >}
     * {@link JAXBElement }{@code <}{@link ForType }{@code >}
     * {@link JAXBElement }{@code <}{@link ControlCommandType }{@code >}
     * {@link JAXBElement }{@code <}{@link AbstractInstanceType }{@code >}
     * {@link JAXBElement }{@code <}{@link SetupMethodsType }{@code >}
     * {@link JAXBElement }{@code <}{@link InstanceType }{@code >}
     * {@link JAXBElement }{@code <}{@link SetupCommandType }{@code >}
     * {@link JAXBElement }{@code <}{@link StructureType }{@code >}
     * {@link JAXBElement }{@code <}{@link CommandType }{@code >}
     * 
     * 
     */
    public List<JAXBElement<? extends CommandType>> getCommand() {
        if (command == null) {
            command = new ArrayList<JAXBElement<? extends CommandType>>();
        }
        return this.command;
    }

}
