//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2012.12.12 at 01:56:52 PM MEZ 
//


package de.tudresden.inf.rn.mobilis.gwtemulationserver.server.script;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.CollapsedStringAdapter;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;


/**
 * <p>Java class for abstractInstanceType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="abstractInstanceType">
 *   &lt;complexContent>
 *     &lt;extension base="{http://mobilis.inf.tu-dresden.de/XMLEmulationScript}setupCommandType">
 *       &lt;attribute name="varName" use="required" type="{http://www.w3.org/2001/XMLSchema}NCName" />
 *       &lt;attribute name="appNS" use="required" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "abstractInstanceType")
@XmlSeeAlso({
    InstanceGroupType.class,
    InstanceType.class
})
public class AbstractInstanceType
    extends SetupCommandType
{

    @XmlAttribute(required = true)
    @XmlJavaTypeAdapter(CollapsedStringAdapter.class)
    @XmlSchemaType(name = "NCName")
    protected String varName;
    @XmlAttribute(required = true)
    protected String appNS;

    /**
     * Gets the value of the varName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVarName() {
        return varName;
    }

    /**
     * Sets the value of the varName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVarName(String value) {
        this.varName = value;
    }

    /**
     * Gets the value of the appNS property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAppNS() {
        return appNS;
    }

    /**
     * Sets the value of the appNS property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAppNS(String value) {
        this.appNS = value;
    }

}
